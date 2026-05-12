// get_exercises_usecase.dart
import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:entrenaop/features/exercises/domain/repositories/exercise_repository.dart';

class GetExercisesUseCase {
  final ExerciseRepository repository;
  GetExercisesUseCase(this.repository);

  Future<List<ExerciseEntity>> call() async {
    return await repository.getExercises();
  }
}
