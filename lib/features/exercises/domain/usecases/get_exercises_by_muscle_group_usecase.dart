import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:entrenaop/features/exercises/domain/repositories/exercise_repository.dart';

class GetExercisesByMuscleGroupUseCase {
  final ExerciseRepository repository;
  GetExercisesByMuscleGroupUseCase(this.repository);

  Future<List<ExerciseEntity>> call(String muscleGroup) async {
    return await repository.getExercisesByMuscleGroup(muscleGroup);
  }
}
