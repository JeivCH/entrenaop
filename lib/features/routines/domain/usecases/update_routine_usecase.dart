import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/domain/repositories/routine_repository.dart';

class UpdateRoutineUseCase {
  final RoutineRepository repository;
  UpdateRoutineUseCase(this.repository);

  Future<void> call(RoutineEntity routine) async {
    return await repository.updateRoutine(routine);
  }
}
