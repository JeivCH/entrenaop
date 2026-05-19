import 'package:entrenaop/features/routines/domain/entities/routine_with_exercises_entity.dart';
import 'package:entrenaop/features/routines/domain/repositories/routine_repository.dart';

class GetRoutineWithExercisesUseCase {
  final RoutineRepository repository;
  GetRoutineWithExercisesUseCase(this.repository);

  Future<RoutineWithExercisesEntity> call(String routineId) async {
    return await repository.getRoutineWithExercises(routineId);
  }
}
