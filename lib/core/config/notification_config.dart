class NotificationConfig {
  static const oneSignalAppId = String.fromEnvironment(
    'ONESIGNAL_APP_ID',
    defaultValue: '57a54040-bea7-45fd-ad2f-45bd7d7be389',
  );

  static bool get hasOneSignalApp => oneSignalAppId.isNotEmpty;

  const NotificationConfig._();
}
