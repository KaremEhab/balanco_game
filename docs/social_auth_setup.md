# Balanco social authentication setup

The Flutter project supports:

- native Google sign-in on Android/iOS when native client IDs are supplied;
- native Sign in with Apple on iOS/macOS;
- Supabase browser OAuth as the fallback on desktop and on mobile builds that do not yet have native Google IDs;
- callback URL `balanco://auth-callback/`;
- mandatory Balanco display name, unique username, and player-selected age after a provider creates a new account.

Never put Google client secrets, Apple `.p8` keys, or Apple generated secrets in the Flutter app or Git. They belong only in Google/Apple/Supabase dashboards.

## 1. Supabase redirect configuration

In Supabase project `xojfseowbcsrfyocfnph`, open **Authentication > URL Configuration** and add this exact Redirect URL:

```text
balanco://auth-callback/
```

The provider callback URL used at Google and Apple is:

```text
https://xojfseowbcsrfyocfnph.supabase.co/auth/v1/callback
```

## 2. Google

In Google Cloud / Google Auth Platform:

1. Configure Branding, Audience, and the `openid`, email, and profile scopes.
2. Create a **Web application** OAuth client. Add the Supabase callback URL above as an authorized redirect URI. Save its client ID and secret.
3. Create an **Android** OAuth client for package `com.balanco.balanco`. Add SHA-1 fingerprints for the local debug key, the production upload key, and Google Play App Signing.
4. Create an **iOS** OAuth client for bundle ID `com.balanco.balanco`.
5. Download a refreshed `google-services.json` and replace `android/app/google-services.json`.

In **Supabase > Authentication > Providers > Google**:

1. Enable Google.
2. Enter this comma-separated value, preserving the Web, iOS, Android order:

```text
936173877697-30n4qllaiir29hi0ta3qa3smoh0l168n.apps.googleusercontent.com,936173877697-nnfffn4013m35bd4hf34hjd1m6vv6brv.apps.googleusercontent.com,936173877697-t738sdi138mb3f31j46f9ja933qsbd9v.apps.googleusercontent.com
```

3. Enter only a current Web client secret directly in Supabase and save. Never store or paste that secret into the Flutter project.
4. Enable **Skip nonce checks** because Balanco uses native Google Sign-In on iOS. Keep **Allow users without an email** disabled.

The public Web and iOS IDs are configured as safe defaults in `SupabaseConfig`, so regular Android/iOS builds need no Google `--dart-define` values. You can still override them for another environment:

```powershell
flutter run --dart-define=GOOGLE_WEB_CLIENT_ID=YOUR_WEB_ID.apps.googleusercontent.com
```

For iOS, also add:

```text
--dart-define=GOOGLE_IOS_CLIENT_ID=YOUR_IOS_ID.apps.googleusercontent.com
```

Native Google sign-in on iOS additionally requires the reversed iOS client ID as a URL scheme in `ios/Runner/Info.plist`. Balanco's current iOS scheme is already configured as:

```xml
<dict>
  <key>CFBundleTypeRole</key>
  <string>Editor</string>
  <key>CFBundleURLSchemes</key>
  <array>
    <string>com.googleusercontent.apps.936173877697-nnfffn4013m35bd4hf34hjd1m6vv6brv</string>
  </array>
</dict>
```

The dictionary is already present as a second entry inside the existing `CFBundleURLTypes` array.

## 3. Apple

For native iPhone/iPad sign-in:

1. In Apple Developer **Certificates, Identifiers & Profiles > Identifiers**, edit App ID `com.balanco.balanco` and enable **Sign in with Apple**.
2. Regenerate the development and App Store provisioning profiles. Fetch/upload the new profiles in the cloud build service. The old profiles will fail because the project now contains the Sign in with Apple entitlement.
3. In **Supabase > Authentication > Providers > Apple**, enable Apple and include `com.balanco.balanco` in Client IDs.

To also support Apple sign-in from Android/Windows browser OAuth:

1. Create an Apple Services ID such as `com.balanco.balanco.web`, linked to the Balanco App ID.
2. Configure its website domain as `xojfseowbcsrfyocfnph.supabase.co` and return URL as the Supabase provider callback URL above.
3. Create a Sign in with Apple key, download the `.p8` once, and securely store it.
4. Generate the Apple client secret in Supabase using the Team ID, Key ID, Services ID, and `.p8` key.
5. Put the Services ID first and `com.balanco.balanco` second in Supabase's Apple Client IDs field.
6. Rotate the Apple web OAuth secret before its six-month expiry. Native-only iOS sign-in does not need this rotation.

## 4. Real-device checks

- Google Android: test a debug build, then a Play internal-testing build because they use different signing SHA fingerprints.
- Google iOS: test a cloud-built IPA after adding the reversed client ID URL scheme.
- Apple iOS: test on a real signed device; Apple capability testing cannot be completed with an unsigned build.
- Windows: the packaged installer must register `balanco` as a custom URL protocol so the browser can return to the app. Android and iOS registration is already included in this repository.
- New social account: Balanco must show the profile dialog and require display name, username, and age before gameplay. It should receive 5,000 coins, $5.00, and five sparks once.
- Existing email account with the same verified provider email: Supabase automatically links the identity instead of creating duplicate progress.
