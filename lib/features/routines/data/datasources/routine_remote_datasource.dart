import 'package:entrenaop/features/routines/data/models/routine_exercise_model.dart';
import 'package:entrenaop/features/routines/data/models/routine_model.dart';

abstract class RoutineRemoteDataSource {
  Future<List<RoutineModel>> getPublicRoutines();
  Future<List<RoutineModel>> getRoutinesByUser(String userId);
  Future<List<RoutineModel>> getAssignedRoutines(String userId);
  Future<RoutineModel?> getRoutineById(String id);
  Future<List<RoutineExerciseModel>> getRoutineExercises(String routineId);
  Future<void> createRoutine(RoutineModel routine);
  Future<void> updateRoutine(RoutineModel routine);
  Future<void> deleteRoutine(String id);
  Future<void> assignRoutine(String routineId, String userId);
}
