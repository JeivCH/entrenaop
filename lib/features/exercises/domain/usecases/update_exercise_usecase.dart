// update_exercise_usecase.dart
import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:entrenaop/features/exercises/domain/repositories/exercise_repository.dart';

class UpdateExerciseUseCase {
  final ExerciseRepository repository;
  UpdateExerciseUseCase(this.repository);

  Future<void> call(ExerciseEntity exercise) async {
    return await repository.updateExercise(exercise);
  }
}
