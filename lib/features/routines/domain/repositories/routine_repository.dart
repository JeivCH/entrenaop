import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/domain/entities/routine_with_exercises_entity.dart';

abstract class RoutineRepository {
  Future<List<RoutineEntity>> getPublicRoutines();
  Future<List<RoutineEntity>> getRoutinesByUser(String userId);
  Future<List<RoutineEntity>> getAssignedRoutines(String userId);
  Future<RoutineEntity?> getRoutineById(String id);
  Future<RoutineWithExercisesEntity> getRoutineWithExercises(String routineId);
  Future<void> createRoutine(RoutineEntity routine);
  Future<void> updateRoutine(RoutineEntity routine);
  Future<void> deleteRoutine(String id);
  Future<void> assignRoutine(String routineId, String userId);
}
