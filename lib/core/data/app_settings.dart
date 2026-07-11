import 'package:flutter/foundation.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:balanco_game/core/data/database_helper.dart';

enum SoundChannel { impacts, hazards, rewards, ui }

class AppSettings {
  static final ValueNotifier<bool> soundEnabled = ValueNotifier(true);
  static final ValueNotifier<double> musicVolume = ValueNotifier(0.75);
  static final ValueNotifier<double> impactsVolume = ValueNotifier(0.9);
  static final ValueNotifier<double> hazardsVolume = ValueNotifier(0.9);
  static final ValueNotifier<double> rewardsVolume = ValueNotifier(0.9);
  static final ValueNotifier<double> uiVolume = ValueNotifier(0.8);
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

    await _loadVolume(db, 'music_volume', musicVolume);
    await _loadVolume(db, 'impacts_volume', impactsVolume);
    await _loadVolume(db, 'hazards_volume', hazardsVolume);
    await _loadVolume(db, 'rewards_volume', rewardsVolume);
    await _loadVolume(db, 'ui_volume', uiVolume);

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
      } else {
        playMenuBgm();
      }
    });
  }

  static void setSoundEnabled(bool value) {
    soundEnabled.value = value;
    DatabaseHelper.instance.saveConfig('sound_enabled', value.toString());
  }

  static Future<void> _loadVolume(
    DatabaseHelper db,
    String key,
    ValueNotifier<double> notifier,
  ) async {
    final config = await db.getConfig(key);
    if (config != null) {
      notifier.value = (double.tryParse(config) ?? notifier.value)
          .clamp(0.0, 1.0)
          .toDouble();
    }
  }

  static void setChannelVolume(SoundChannel channel, double value) {
    final clamped = value.clamp(0.0, 1.0).toDouble();
    final (notifier, key) = switch (channel) {
      SoundChannel.impacts => (impactsVolume, 'impacts_volume'),
      SoundChannel.hazards => (hazardsVolume, 'hazards_volume'),
      SoundChannel.rewards => (rewardsVolume, 'rewards_volume'),
      SoundChannel.ui => (uiVolume, 'ui_volume'),
    };
    notifier.value = clamped;
    DatabaseHelper.instance.saveConfig(key, clamped.toString());
  }

  static void setMusicVolume(double value) {
    musicVolume.value = value.clamp(0.0, 1.0).toDouble();
    DatabaseHelper.instance.saveConfig(
      'music_volume',
      musicVolume.value.toString(),
    );
    if (musicVolume.value == 0) {
      stopBgm();
    } else if (soundEnabled.value) {
      stopBgm();
      playMenuBgm();
    }
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
    SoundChannel? channel,
  }) async {
    if (soundEnabled.value) {
      try {
        final channelVolume = _volumeFor(channel ?? _channelForFile(file));
        if (channelVolume <= 0) return null;
        return await FlameAudio.play(file, volume: volume * channelVolume);
      } catch (_) {}
    }
    return null;
  }

  static SoundChannel _channelForFile(String file) {
    if (file.contains('star') || file.contains('win')) {
      return SoundChannel.rewards;
    }
    if (file.contains('tick') ||
        file.contains('heartbeat') ||
        file.contains('bomb')) {
      return SoundChannel.hazards;
    }
    if (file.contains('bump') ||
        file.contains('bounce') ||
        file.contains('fall') ||
        file.contains('hole') ||
        file.contains('thud') ||
        file.contains('crack') ||
        file.contains('gameover')) {
      return SoundChannel.impacts;
    }
    return SoundChannel.ui;
  }

  static double _volumeFor(SoundChannel channel) => switch (channel) {
    SoundChannel.impacts => impactsVolume.value,
    SoundChannel.hazards => hazardsVolume.value,
    SoundChannel.rewards => rewardsVolume.value,
    SoundChannel.ui => uiVolume.value,
  };

  static Future<void> initBgm() async {
    if (!_bgmInitialized) {
      FlameAudio.bgm.initialize();
      try {
        await FlameAudio.audioCache.loadAll([
          'gameplay-main-sound.wav',
          'bounce.wav',
          'bump.wav',
        ]);
      } catch (e) {
        debugPrint('BGM Cache Error: $e');
      }
      _bgmInitialized = true;
    }
  }

  static Future<void> playMenuBgm() async {
    if (soundEnabled.value && musicVolume.value > 0) {
      await initBgm();
      try {
        FlameAudio.bgm.play(
          'gameplay-main-sound.wav',
          volume: musicVolume.value,
        );
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
