import 'package:entrenaop/features/session/data/models/session_log_model.dart';

abstract class SessionRemoteDataSource {
  Future<void> createSessionLog(SessionLogModel log);
  Future<List<SessionLogModel>> getSessionLogsByUser(String userId);
}
