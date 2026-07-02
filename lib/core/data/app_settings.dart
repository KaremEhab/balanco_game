import 'package:flutter/foundation.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:balanco_game/core/data/database_helper.dart';

class AppSettings {
  static final ValueNotifier<bool> soundEnabled = ValueNotifier(true);
  static final ValueNotifier<double> joystickSensitivity = ValueNotifier(1.0);

  static Future<void> init() async {
    final db = DatabaseHelper.instance;
    final soundConfig = await db.getConfig('sound_enabled');
    if (soundConfig != null) {
      soundEnabled.value = soundConfig == 'true';
    }
    
    final sensitivityConfig = await db.getConfig('joystick_sensitivity');
    if (sensitivityConfig != null) {
      joystickSensitivity.value = double.tryParse(sensitivityConfig) ?? 1.0;
    }
  }

  static void setSoundEnabled(bool value) {
    soundEnabled.value = value;
    DatabaseHelper.instance.saveConfig('sound_enabled', value.toString());
  }

  static void setJoystickSensitivity(double value) {
    joystickSensitivity.value = value;
    DatabaseHelper.instance.saveConfig('joystick_sensitivity', value.toString());
  }

  static Future<AudioPlayer?> playSound(String file, {double volume = 1.0}) async {
    if (soundEnabled.value) {
      try {
        return await FlameAudio.play(file, volume: volume);
      } catch (_) {}
    }
    return null;
  }
}
