import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/domain/repositories/routine_repository.dart';

class CreateRoutineUseCase {
  final RoutineRepository repository;
  CreateRoutineUseCase(this.repository);

  Future<void> call(RoutineEntity routine) async {
    return await repository.createRoutine(routine);
  }
}
