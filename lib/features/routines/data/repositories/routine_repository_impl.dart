import 'package:entrenaop/features/routines/data/datasources/routine_remote_datasource.dart';
import 'package:entrenaop/features/routines/data/models/routine_model.dart';
import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/domain/entities/routine_with_exercises_entity.dart';
import 'package:entrenaop/features/routines/domain/repositories/routine_repository.dart';

class RoutineRepositoryImpl implements RoutineRepository {
  final RoutineRemoteDataSource remoteDataSource;

  RoutineRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<RoutineEntity>> getPublicRoutines() async {
    return await remoteDataSource.getPublicRoutines();
  }

  @override
  Future<List<RoutineEntity>> getRoutinesByUser(String userId) async {
    return await remoteDataSource.getRoutinesByUser(userId);
  }

  @override
  Future<List<RoutineEntity>> getAssignedRoutines(String userId) async {
    return await remoteDataSource.getAssignedRoutines(userId);
  }

  @override
  Future<RoutineEntity?> getRoutineById(String id) async {
    return await remoteDataSource.getRoutineById(id);
  }

  @override
  Future<RoutineWithExercisesEntity> getRoutineWithExercises(String routineId) async {
    final routine = await remoteDataSource.getRoutineById(routineId);
    if (routine == null) throw Exception('Rutina no encontrada');
    final exercises = await remoteDataSource.getRoutineExercises(routineId);
    return RoutineWithExercisesEntity(routine: routine, exercises: exercises);
  }

  @override
  Future<void> createRoutine(RoutineEntity routine) async {
    return await remoteDataSource.createRoutine(routine as RoutineModel);
  }

  @override
  Future<void> updateRoutine(RoutineEntity routine) async {
    return await remoteDataSource.updateRoutine(routine as RoutineModel);
  }

  @override
  Future<void> deleteRoutine(String id) async {
    return await remoteDataSource.deleteRoutine(id);
  }

  @override
  Future<void> assignRoutine(String routineId, String userId) async {
    return await remoteDataSource.assignRoutine(routineId, userId);
  }
}
