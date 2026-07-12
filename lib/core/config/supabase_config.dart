class SupabaseConfig {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xojfseowbcsrfyocfnph.supabase.co',
  );
  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_C_MjTG4Sn_5BVu5IC-GbAg_EF3DB3eE',
  );

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;

  const SupabaseConfig._();
}
