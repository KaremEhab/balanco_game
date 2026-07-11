import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart'; // For compute()
import 'package:balanco_game/core/data/models.dart';

// Top-level function for Isolate computation
List<LevelProgress> _parseLevelProgressList(
  List<Map<String, Object?>> jsonList,
) {
  return jsonList.map((json) => LevelProgress.fromMap(json)).toList();
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  
  final ValueNotifier<PlayerProfile?> profileNotifier = ValueNotifier(null);

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('balanco_game.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE player_profile (
  id INTEGER PRIMARY KEY,
  isFirstOpen INTEGER NOT NULL,
  highestLevel INTEGER NOT NULL,
  lastPlayedLevel INTEGER NOT NULL,
  coins INTEGER NOT NULL,
  streak INTEGER NOT NULL,
  infinity_high_score INTEGER DEFAULT 0
)
''');

    await db.execute('''
CREATE TABLE level_progress (
  level_id INTEGER PRIMARY KEY,
  stars INTEGER NOT NULL,
  is_unlocked INTEGER NOT NULL
)
''');

    await db.execute('''
CREATE TABLE app_config (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
)
''');

    await db.execute('''
CREATE TABLE custom_levels (
  level_id INTEGER PRIMARY KEY,
  is_infinity INTEGER NOT NULL DEFAULT 0,
  level_json TEXT NOT NULL
)
''');

    // Insert default player profile
    await db.insert('player_profile', {
      'id': 1,
      'isFirstOpen': 1,
      'highestLevel': 1,
      'lastPlayedLevel': 1,
      'coins': 1200, // starting coins (from UI placeholder)
      'streak': 5, // starting streak (from UI placeholder)
      'infinity_high_score': 0,
    });
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE player_profile ADD COLUMN infinity_high_score INTEGER DEFAULT 0',
      );
    }
    if (oldVersion < 3) {
      await db.execute('''
CREATE TABLE custom_levels (
  level_id INTEGER PRIMARY KEY,
  is_infinity INTEGER NOT NULL DEFAULT 0,
  level_json TEXT NOT NULL
)
''');
    }
  }

  // --- Player Profile ---

  Future<PlayerProfile> getPlayerProfile() async {
    final db = await instance.database;
    final maps = await db.query(
      'player_profile',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isNotEmpty) {
      final profile = PlayerProfile.fromMap(maps.first);
      profileNotifier.value = profile;
      return profile;
    } else {
      throw Exception('Player profile not found');
    }
  }

  Future<void> updatePlayerProfile(PlayerProfile profile) async {
    final db = await instance.database;
    await db.update(
      'player_profile',
      profile.toMap(),
      where: 'id = ?',
      whereArgs: [1],
    );
    profileNotifier.value = profile;
  }

  // --- Level Progress ---

  Future<LevelProgress?> getLevelProgress(int levelId) async {
    final db = await instance.database;
    final maps = await db.query(
      'level_progress',
      where: 'level_id = ?',
      whereArgs: [levelId],
    );

    if (maps.isNotEmpty) {
      return LevelProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<List<LevelProgress>> getAllLevelProgress() async {
    final db = await instance.database;
    final result = await db.query('level_progress');
    // Offload JSON parsing to a background isolate
    return await compute(_parseLevelProgressList, result);
  }

  Future<void> saveLevelProgress(LevelProgress progress) async {
    final db = await instance.database;
    await db.insert(
      'level_progress',
      progress.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // --- App Config (Key-Value) ---

  Future<String?> getConfig(String key) async {
    final db = await instance.database;
    final maps = await db.query(
      'app_config',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isNotEmpty) {
      return maps.first['value'] as String;
    }
    return null;
  }

  Future<void> saveConfig(String key, String value) async {
    final db = await instance.database;
    await db.insert('app_config', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteConfig(String key) async {
    final db = await instance.database;
    await db.delete('app_config', where: 'key = ?', whereArgs: [key]);
  }

  // --- Custom Levels (Editor) ---

  Future<void> saveCustomLevel(int levelId, String jsonStr, {bool isInfinity = false}) async {
    final db = await instance.database;
    await db.insert(
      'custom_levels',
      {
        'level_id': levelId,
        'is_infinity': isInfinity ? 1 : 0,
        'level_json': jsonStr,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getCustomLevel(int levelId) async {
    final db = await instance.database;
    final maps = await db.query(
      'custom_levels',
      columns: ['level_json'],
      where: 'level_id = ?',
      whereArgs: [levelId],
    );

    if (maps.isNotEmpty) {
      return maps.first['level_json'] as String;
    }
    return null;
  }
}
