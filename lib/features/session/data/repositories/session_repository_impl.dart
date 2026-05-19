import 'package:entrenaop/features/session/data/datasources/session_remote_datasource.dart';
import 'package:entrenaop/features/session/data/models/session_log_model.dart';
import 'package:entrenaop/features/session/domain/entities/session_log_entity.dart';
import 'package:entrenaop/features/session/domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource remoteDataSource;

  SessionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createSessionLog(SessionLogEntity log) async {
    return await remoteDataSource.createSessionLog(log as SessionLogModel);
  }

  @override
  Future<List<SessionLogEntity>> getSessionLogsByUser(String userId) async {
    return await remoteDataSource.getSessionLogsByUser(userId);
  }
}
