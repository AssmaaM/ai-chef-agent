import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../domain/models/cooking_session.dart';
import '../../domain/repositories/session_repository.dart';
import '../security/encryption_service.dart';

class SessionRepositoryImpl implements SessionRepository {
  final Database _db;
  final EncryptionService _encryptionService;

  SessionRepositoryImpl(this._db, this._encryptionService);

  @override
  Future<void> saveSession(CookingSession session) async {
    final jsonData = jsonEncode(session.toJson());
    final encryptedData = await _encryptionService.encrypt(jsonData);

    await _db.insert(
      'cooking_sessions',
      {'id': session.id, 'data': encryptedData},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<CookingSession?> getLastSession() async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'cooking_sessions',
      orderBy: 'id DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;

    final encryptedData = maps.first['data'] as String;
    final jsonData = await _encryptionService.decrypt(encryptedData);
    return CookingSession.fromJson(jsonDecode(jsonData));
  }

  @override
  Future<List<CookingSession>> getHistory() async {
    final List<Map<String, dynamic>> maps = await _db.query('cooking_sessions');
    final sessions = <CookingSession>[];
    for (final m in maps) {
      final encryptedData = m['data'] as String;
      final jsonData = await _encryptionService.decrypt(encryptedData);
      sessions.add(CookingSession.fromJson(jsonDecode(jsonData)));
    }
    return sessions;
  }
}
