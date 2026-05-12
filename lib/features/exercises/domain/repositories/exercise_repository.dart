import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';

abstract class ExerciseRepository {
  // Define the methods and properties for the ExerciseRepository

  //lectura
  Future<List<ExerciseEntity>> getExercises();
  Future<List<ExerciseEntity>> getExerciseByMuscleGroup(String muscleGroup);
  Future<ExerciseEntity?> getExerciseById(String id);

  //escritura
  Future<void> createExercise(ExerciseEntity exercise);
  Future<void> updateExercise(ExerciseEntity exercise);
  Future<void> deleteExercise(String id);
}
