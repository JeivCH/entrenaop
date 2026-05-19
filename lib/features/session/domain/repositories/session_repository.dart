import 'package:entrenaop/features/session/domain/entities/session_log_entity.dart';

abstract class SessionRepository {
  Future<void> createSessionLog(SessionLogEntity log);
  Future<List<SessionLogEntity>> getSessionLogsByUser(String userId);
}
