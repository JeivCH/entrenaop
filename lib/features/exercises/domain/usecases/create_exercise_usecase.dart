import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:entrenaop/features/exercises/domain/repositories/exercise_repository.dart';

class CreateExerciseUseCase {
  final ExerciseRepository repository;

  CreateExerciseUseCase({required this.repository});

  Future<void> call(ExerciseEntity exercise) async {
    return await repository.createExercise(exercise);
  }
}
