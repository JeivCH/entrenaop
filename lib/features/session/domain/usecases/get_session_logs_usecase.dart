import 'package:entrenaop/features/session/domain/entities/session_log_entity.dart';
import 'package:entrenaop/features/session/domain/repositories/session_repository.dart';

class GetSessionLogsUseCase {
  final SessionRepository repository;
  GetSessionLogsUseCase(this.repository);

  Future<List<SessionLogEntity>> call(String userId) async {
    return await repository.getSessionLogsByUser(userId);
  }
}
