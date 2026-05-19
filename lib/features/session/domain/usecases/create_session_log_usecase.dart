import 'package:entrenaop/features/session/domain/entities/session_log_entity.dart';
import 'package:entrenaop/features/session/domain/repositories/session_repository.dart';

class CreateSessionLogUseCase {
  final SessionRepository repository;
  CreateSessionLogUseCase(this.repository);

  Future<void> call(SessionLogEntity log) async {
    return await repository.createSessionLog(log);
  }
}
