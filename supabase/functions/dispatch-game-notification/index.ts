import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const jsonHeaders = { "Content-Type": "application/json" } as const;
const defaultOneSignalAppId = "57a54040-bea7-45fd-ad2f-45bd7d7be389";
const requestTimeoutMs = 15_000;
const uuidPattern =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

type JsonObject = Record<string, unknown>;

type NotificationRecord = {
  id: string;
  recipient_id: string;
  notification_type: string;
  title: string;
  body: string;
  data: JsonObject;
  push_status: "pending" | "processing" | "sent" | "failed";
  push_attempts: number;
};

class HttpError extends Error {
  constructor(
    message: string,
    readonly status: number,
  ) {
    super(message);
  }
}

function jsonResponse(body: JsonObject, status = 200) {
  return Response.json(body, { status, headers: jsonHeaders });
}

function getAdminKey(): string | null {
  const currentKeys = Deno.env.get("SUPABASE_SECRET_KEYS");
  if (currentKeys) {
    try {
      const parsed = JSON.parse(currentKeys) as Record<string, unknown>;
      const defaultKey = parsed.default;
      if (typeof defaultKey === "string" && defaultKey.length > 0) {
        return defaultKey;
      }
    } catch (error) {
      console.error("SUPABASE_SECRET_KEYS is not valid JSON", error);
    }
  }

  return Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? null;
}

function adminHeaders(
  adminKey: string,
  extra: Record<string, string> = {},
) {
  const headers: Record<string, string> = {
    ...jsonHeaders,
    apikey: adminKey,
    ...extra,
  };

  // New sb_secret keys belong only in `apikey`. Legacy service-role JWTs
  // still require the Authorization header for PostgREST compatibility.
  if (!adminKey.startsWith("sb_secret_")) {
    headers.Authorization = `Bearer ${adminKey}`;
  }
  return headers;
}

function notificationUrl(
  restUrl: string,
  notificationId: string,
  statusFilter?: string,
) {
  const url = new URL(`${restUrl}/player_notifications`);
  url.searchParams.set("id", `eq.${notificationId}`);
  if (statusFilter) {
    url.searchParams.set("push_status", `in.(${statusFilter})`);
  }
  return url;
}

async function request(
  input: string | URL,
  init: RequestInit,
): Promise<Response> {
  return fetch(input, {
    ...init,
    signal: AbortSignal.timeout(requestTimeoutMs),
  });
}

async function patchNotification(
  restUrl: string,
  adminKey: string,
  id: string,
  values: JsonObject,
  statusFilter?: string,
): Promise<NotificationRecord[]> {
  const result = await request(
    notificationUrl(restUrl, id, statusFilter),
    {
      method: "PATCH",
      headers: adminHeaders(adminKey, { Prefer: "return=representation" }),
      body: JSON.stringify(values),
    },
  );
  if (!result.ok) {
    const details = (await result.text()).slice(0, 500);
    throw new HttpError(`Notification update failed: ${details}`, 502);
  }
  return (await result.json()) as NotificationRecord[];
}

async function hasValidWebhookSecret(
  restUrl: string,
  adminKey: string,
  candidate: string | null,
) {
  if (!candidate) return false;
  const check = await request(
    `${restUrl}/rpc/verify_notification_webhook_secret`,
    {
      method: "POST",
      headers: adminHeaders(adminKey),
      body: JSON.stringify({ p_candidate: candidate }),
    },
  );
  return check.ok && (await check.json()) === true;
}

async function readPayload(request: Request): Promise<JsonObject> {
  try {
    const value: unknown = await request.json();
    if (value == null || typeof value !== "object" || Array.isArray(value)) {
      throw new Error("JSON body must be an object");
    }
    return value as JsonObject;
  } catch (_) {
    throw new HttpError("Invalid JSON body", 400);
  }
}

function getNotificationId(payload: JsonObject): string {
  const webhookRecord = payload.record;
  const recordId =
    webhookRecord != null &&
      typeof webhookRecord === "object" &&
      !Array.isArray(webhookRecord)
      ? (webhookRecord as JsonObject).id
      : null;
  const id = payload.notification_id ?? recordId;
  if (typeof id !== "string" || !uuidPattern.test(id)) {
    throw new HttpError("A valid notification_id is required", 400);
  }
  return id;
}

async function loadNotification(
  restUrl: string,
  adminKey: string,
  notificationId: string,
) {
  const url = notificationUrl(restUrl, notificationId);
  url.searchParams.set("select", "*");
  const result = await request(url, { headers: adminHeaders(adminKey) });
  if (!result.ok) {
    throw new HttpError("Notification lookup failed", 502);
  }
  const rows = (await result.json()) as NotificationRecord[];
  if (rows.length === 0) {
    throw new HttpError("Notification not found", 404);
  }
  return rows[0];
}

async function sendWithOneSignal(
  notification: NotificationRecord,
  appId: string,
  apiKey: string,
) {
  const result = await request("https://api.onesignal.com/notifications", {
    method: "POST",
    headers: {
      ...jsonHeaders,
      Authorization: `Key ${apiKey}`,
    },
    body: JSON.stringify({
      app_id: appId,
      name: `Balanco ${notification.notification_type}`,
      target_channel: "push",
      include_aliases: { external_id: [notification.recipient_id] },
      headings: { en: notification.title },
      contents: { en: notification.body },
      data: {
        ...notification.data,
        route: "notifications",
        notification_id: notification.id,
        notification_type: notification.notification_type,
      },
      idempotency_key: notification.id,
      ttl: 86_400,
    }),
  });

  const responseText = await result.text();
  let delivery: JsonObject = {};
  if (responseText) {
    try {
      delivery = JSON.parse(responseText) as JsonObject;
    } catch (_) {
      delivery = { raw_response: responseText.slice(0, 500) };
    }
  }
  if (!result.ok) {
    throw new HttpError(
      `OneSignal delivery failed: ${responseText.slice(0, 500)}`,
      502,
    );
  }
  return delivery;
}

Deno.serve(async (incomingRequest: Request) => {
  if (incomingRequest.method !== "POST") {
    return jsonResponse({ error: "Method not allowed" }, 405);
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL");
  const adminKey = getAdminKey();
  const oneSignalApiKey = Deno.env.get("ONESIGNAL_REST_API_KEY");
  const oneSignalAppId =
    Deno.env.get("ONESIGNAL_APP_ID") ?? defaultOneSignalAppId;
  if (!supabaseUrl || !adminKey) {
    return jsonResponse(
      { error: "Supabase runtime configuration is missing" },
      500,
    );
  }

  const restUrl = `${supabaseUrl}/rest/v1`;
  try {
    const isAuthorized = await hasValidWebhookSecret(
      restUrl,
      adminKey,
      incomingRequest.headers.get("x-balanco-webhook-secret"),
    );
    if (!isAuthorized) throw new HttpError("Unauthorized", 401);
    if (!oneSignalApiKey) {
      throw new HttpError("ONESIGNAL_REST_API_KEY is not configured", 503);
    }

    const payload = await readPayload(incomingRequest);
    const notificationId = getNotificationId(payload);
    const notification = await loadNotification(
      restUrl,
      adminKey,
      notificationId,
    );

    if (notification.push_status === "sent") {
      return jsonResponse({ ok: true, duplicate: true });
    }

    const claimed = await patchNotification(
      restUrl,
      adminKey,
      notification.id,
      {
        push_status: "processing",
        push_attempts: notification.push_attempts + 1,
        push_error: null,
      },
      "pending,failed",
    );
    if (claimed.length === 0) {
      return jsonResponse({ ok: true, already_processing: true }, 202);
    }

    try {
      const delivery = await sendWithOneSignal(
        notification,
        oneSignalAppId,
        oneSignalApiKey,
      );
      await patchNotification(restUrl, adminKey, notification.id, {
        push_status: "sent",
        push_sent_at: new Date().toISOString(),
        push_error: null,
      });
      return jsonResponse({ ok: true, delivery });
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      try {
        await patchNotification(restUrl, adminKey, notification.id, {
          push_status: "failed",
          push_error: message.slice(0, 1000),
        });
      } catch (updateError) {
        console.error("Could not persist push failure", updateError);
      }
      throw error;
    }
  } catch (error) {
    console.error("Notification dispatch failed", error);
    const status = error instanceof HttpError ? error.status : 500;
    const message = error instanceof Error
      ? error.message
      : "Unexpected notification dispatch failure";
    return jsonResponse({ error: message }, status);
  }
});
