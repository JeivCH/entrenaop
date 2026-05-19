import 'package:entrenaop/features/routines/domain/repositories/routine_repository.dart';

class DeleteRoutineUseCase {
  final RoutineRepository repository;
  DeleteRoutineUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteRoutine(id);
  }
}
