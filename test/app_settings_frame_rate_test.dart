import 'package:balanco_game/core/data/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    AppSettings.gameplayFrameRate.value = 60;
    AppSettings.configureOwnerFrameRateAccess(null);
  });

  test('120 FPS is available to the configured owner', () {
    AppSettings.gameplayFrameRate.value = 120;
    AppSettings.configureOwnerFrameRateAccess('karemehab2323@gmail.com');

    expect(AppSettings.effectiveGameplayFrameRate, 120);
  });

  test('non-owner gameplay remains capped at 60 FPS', () {
    AppSettings.gameplayFrameRate.value = 120;
    AppSettings.configureOwnerFrameRateAccess('another@example.com');

    expect(AppSettings.effectiveGameplayFrameRate, 60);
  });
}
