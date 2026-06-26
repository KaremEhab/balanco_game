import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('balanco_game.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE player_profile (
  id INTEGER PRIMARY KEY,
  isFirstOpen INTEGER NOT NULL,
  highestLevel INTEGER NOT NULL,
  lastPlayedLevel INTEGER NOT NULL,
  coins INTEGER NOT NULL,
  streak INTEGER NOT NULL
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

    // Insert default player profile
    await db.insert('player_profile', {
      'id': 1,
      'isFirstOpen': 1,
      'highestLevel': 1,
      'lastPlayedLevel': 1,
      'coins': 1200, // starting coins (from UI placeholder)
      'streak': 5, // starting streak (from UI placeholder)
    });
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
      return PlayerProfile.fromMap(maps.first);
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
    return result.map((json) => LevelProgress.fromMap(json)).toList();
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
    await db.insert(
      'app_config',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteConfig(String key) async {
    final db = await instance.database;
    await db.delete(
      'app_config',
      where: 'key = ?',
      whereArgs: [key],
    );
  }
}
