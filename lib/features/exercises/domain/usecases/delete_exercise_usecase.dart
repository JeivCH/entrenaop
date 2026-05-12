// delete_exercise_usecase.dart
import 'package:entrenaop/features/exercises/domain/repositories/exercise_repository.dart';

class DeleteExerciseUseCase {
  final ExerciseRepository repository;
  DeleteExerciseUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteExercise(id);
  }
}
