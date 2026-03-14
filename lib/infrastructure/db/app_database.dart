import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../security/encryption_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// SQLite database bootstrap.
///
/// NOTE: Schema is intentionally simplified. In a full implementation
/// you would add migrations, indices, and proper encryption.
class AppDatabase {
  static Database? _db;
  static EncryptionService? _encryptionService;

  static EncryptionService get encryptionService {
    _encryptionService ??= EncryptionService(const FlutterSecureStorage());
    return _encryptionService!;
  }

  static Future<Database> open() async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, 'ai_chef_agent.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE recipes (
            id TEXT PRIMARY KEY,
            data TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE cooking_sessions (
            id TEXT PRIMARY KEY,
            data TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE user_preferences (
            id TEXT PRIMARY KEY,
            data TEXT NOT NULL
          );
        ''');
      },
    );

    return _db!;
  }
}

