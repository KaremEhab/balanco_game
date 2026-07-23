class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xojfseowbcsrfyocfnph.supabase.co',
  );
  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_C_MjTG4Sn_5BVu5IC-GbAg_EF3DB3eE',
  );
  static const authRedirectUrl = String.fromEnvironment(
    'SUPABASE_AUTH_REDIRECT_URL',
    defaultValue: 'balanco://auth-callback/',
  );
  static const region = String.fromEnvironment(
    'SUPABASE_REGION',
    defaultValue: 'eu-central-2 (Zurich)',
  );
  static const googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '936173877697-30n4qllaiir29hi0ta3qa3smoh0l168n.apps.googleusercontent.com',
  );
  static const googleIosClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue:
        '936173877697-nnfffn4013m35bd4hf34hjd1m6vv6brv.apps.googleusercontent.com',
  );

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;

  const SupabaseConfig._();
}
