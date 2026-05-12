import 'package:entrenaop/features/exercises/data/models/exercise_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<List<ExerciseModel>> getExercises();
  Future<List<ExerciseModel>> getExercisesByMuscleGroup(String muscleGroup);
  Future<ExerciseModel?> getExerciseById(String id);

  //escritura
  Future<void> createExercise(ExerciseModel exercise);
  Future<void> updateExercise(ExerciseModel exercise);
  Future<void> deleteExercise(String id);
}
