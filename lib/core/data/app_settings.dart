import 'package:flutter/foundation.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:balanco_game/core/data/database_helper.dart';

class AppSettings {
  static final ValueNotifier<bool> soundEnabled = ValueNotifier(true);
  static final ValueNotifier<bool> hapticsEnabled = ValueNotifier(true);
  static final ValueNotifier<bool> parallaxEnabled = ValueNotifier(true);
  static final ValueNotifier<double> joystickSensitivity = ValueNotifier(1.0);
  static final ValueNotifier<int> lastEditedLevel = ValueNotifier(1);
  static final ValueNotifier<String> playerName = ValueNotifier('KAREEM EHAB');

  static bool _bgmInitialized = false;

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

    final hapticsConfig = await db.getConfig('haptics_enabled');
    if (hapticsConfig != null) {
      hapticsEnabled.value = hapticsConfig == 'true';
    }

    final parallaxConfig = await db.getConfig('parallax_enabled');
    if (parallaxConfig != null) {
      parallaxEnabled.value = parallaxConfig == 'true';
    }

    final lastEditedLevelConfig = await db.getConfig('last_edited_level');
    if (lastEditedLevelConfig != null) {
      lastEditedLevel.value = int.tryParse(lastEditedLevelConfig) ?? 1;
    }

    final nameConfig = await db.getConfig('player_name');
    if (nameConfig != null) {
      playerName.value = nameConfig;
    }

    soundEnabled.addListener(() {
      if (!soundEnabled.value) {
        stopBgm();
      }
    });
  }

  static void setSoundEnabled(bool value) {
    soundEnabled.value = value;
    DatabaseHelper.instance.saveConfig('sound_enabled', value.toString());
  }

  static void setJoystickSensitivity(double value) {
    joystickSensitivity.value = value;
    DatabaseHelper.instance.saveConfig(
      'joystick_sensitivity',
      value.toString(),
    );
  }

  static void setHapticsEnabled(bool value) {
    hapticsEnabled.value = value;
    DatabaseHelper.instance.saveConfig('haptics_enabled', value.toString());
  }

  static void setParallaxEnabled(bool value) {
    parallaxEnabled.value = value;
    DatabaseHelper.instance.saveConfig('parallax_enabled', value.toString());
  }

  static void setPlayerName(String name) {
    playerName.value = name;
    DatabaseHelper.instance.saveConfig('player_name', name);
  }

  static void setLastEditedLevel(int value) {
    lastEditedLevel.value = value;
    DatabaseHelper.instance.saveConfig('last_edited_level', value.toString());
  }

  static Future<AudioPlayer?> playSound(
    String file, {
    double volume = 1.0,
  }) async {
    if (soundEnabled.value) {
      try {
        return await FlameAudio.play(file, volume: volume);
      } catch (_) {}
    }
    return null;
  }

  static Future<void> initBgm() async {
    if (!_bgmInitialized) {
      FlameAudio.bgm.initialize();
      try {
        await FlameAudio.audioCache.load('gameplay-main-sound.mp3');
      } catch (e) {
        debugPrint('BGM Cache Error: $e');
      }
      _bgmInitialized = true;
    }
  }

  static Future<void> playMenuBgm() async {
    if (soundEnabled.value) {
      await initBgm();
      try {
        FlameAudio.bgm.play('gameplay-main-sound.mp3', volume: 1.0);
      } catch (e) {
        debugPrint('BGM Error: $e');
      }
    }
  }

  static void stopBgm() {
    if (_bgmInitialized) {
      try {
        FlameAudio.bgm.stop();
      } catch (_) {}
    }
  }
}
