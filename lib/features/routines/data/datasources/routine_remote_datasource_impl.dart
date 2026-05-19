import 'package:entrenaop/core/errors/exceptions.dart';
import 'package:entrenaop/features/routines/data/datasources/routine_remote_datasource.dart';
import 'package:entrenaop/features/routines/data/models/routine_exercise_model.dart';
import 'package:entrenaop/features/routines/data/models/routine_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoutineRemoteDataSourceImpl implements RoutineRemoteDataSource {
  final SupabaseClient supabaseClient;

  RoutineRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<RoutineModel>> getPublicRoutines() async {
    try {
      final response = await supabaseClient
          .from('routines')
          .select()
          .eq('is_public', true)
          .order('name');
      return (response as List).map((j) => RoutineModel.fromJson(j)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RoutineModel>> getRoutinesByUser(String userId) async {
    try {
      final response = await supabaseClient
          .from('routines')
          .select()
          .eq('created_by', userId)
          .eq('routine_type', 'custom')
          .order('name');
      return (response as List).map((j) => RoutineModel.fromJson(j)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RoutineModel>> getAssignedRoutines(String userId) async {
    try {
      final response = await supabaseClient
          .from('routines')
          .select()
          .eq('assigned_to', userId)
          .eq('routine_type', 'assigned')
          .order('name');
      return (response as List).map((j) => RoutineModel.fromJson(j)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<RoutineModel?> getRoutineById(String id) async {
    try {
      final response = await supabaseClient
          .from('routines')
          .select()
          .eq('id', id)
          .single();
      return RoutineModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<RoutineExerciseModel>> getRoutineExercises(String routineId) async {
    try {
      final response = await supabaseClient
          .from('routine_exercises')
          .select('*, exercises(*)')
          .eq('routine_id', routineId)
          .order('order_index');
      return (response as List)
          .map((j) => RoutineExerciseModel.fromJson(j))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> createRoutine(RoutineModel routine) async {
    try {
      await supabaseClient.from('routines').insert(routine.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateRoutine(RoutineModel routine) async {
    try {
      await supabaseClient
          .from('routines')
          .update(routine.toJson())
          .eq('id', routine.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteRoutine(String id) async {
    try {
      await supabaseClient.from('routines').delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> assignRoutine(String routineId, String userId) async {
    try {
      await supabaseClient
          .from('routines')
          .update({'assigned_to': userId, 'routine_type': 'assigned'})
          .eq('id', routineId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
