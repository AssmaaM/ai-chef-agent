import '../models/cooking_session.dart';

abstract class SessionRepository {
  Future<void> saveSession(CookingSession session);
  Future<CookingSession?> getLastSession();
  Future<List<CookingSession>> getHistory();
}
