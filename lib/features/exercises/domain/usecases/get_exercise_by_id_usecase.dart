// get_exercise_by_id_usecase.dart
import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:entrenaop/features/exercises/domain/repositories/exercise_repository.dart';

class GetExerciseByIdUseCase {
  final ExerciseRepository repository;
  GetExerciseByIdUseCase(this.repository);

  Future<ExerciseEntity?> call(String id) async {
    return await repository.getExerciseById(id);
  }
}
