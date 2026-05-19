import 'package:entrenaop/core/errors/exceptions.dart';
import 'package:entrenaop/features/routines/domain/usecases/get_assigned_routines_usecase.dart';
import 'package:entrenaop/features/routines/domain/usecases/get_public_routines_usecase.dart';
import 'package:entrenaop/features/routines/domain/usecases/get_routine_with_exercises_usecase.dart';
import 'package:entrenaop/features/routines/domain/usecases/get_routines_by_user_usecase.dart';
import 'package:entrenaop/features/routines/presentation/bloc/routines_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoutinesCubit extends Cubit<RoutineState> {
  final GetPublicRoutinesUseCase getPublicRoutinesUseCase;
  final GetRoutinesByUserUseCase getRoutinesByUserUseCase;
  final GetAssignedRoutinesUseCase getAssignedRoutinesUseCase;
  final GetRoutineWithExercisesUseCase getRoutineWithExercisesUseCase;

  RoutinesCubit({
    required this.getPublicRoutinesUseCase,
    required this.getRoutinesByUserUseCase,
    required this.getAssignedRoutinesUseCase,
    required this.getRoutineWithExercisesUseCase,
  }) : super(const RoutineInitial());

  Future<void> loadPublicRoutines() async {
    emit(const RoutineLoading());
    try {
      final routines = await getPublicRoutinesUseCase();
      emit(RoutinesLoaded(routines: routines));
    } catch (e) {
      emit(RoutineError(message: e is ServerException ? e.message : e.toString()));
    }
  }

  Future<void> loadUserRoutines(String userId) async {
    emit(const RoutineLoading());
    try {
      final routines = await getRoutinesByUserUseCase(userId);
      emit(RoutinesLoaded(routines: routines));
    } catch (e) {
      emit(RoutineError(message: e is ServerException ? e.message : e.toString()));
    }
  }

  Future<void> loadAssignedRoutines(String userId) async {
    emit(const RoutineLoading());
    try {
      final routines = await getAssignedRoutinesUseCase(userId);
      emit(RoutinesLoaded(routines: routines));
    } catch (e) {
      emit(RoutineError(message: e is ServerException ? e.message : e.toString()));
    }
  }

  Future<void> loadRoutineWithExercises(String routineId) async {
    emit(const RoutineLoading());
    try {
      final routineWithExercises = await getRoutineWithExercisesUseCase(routineId);
      emit(RoutineDetailLoaded(routineWithExercises: routineWithExercises));
    } catch (e) {
      emit(RoutineError(message: e is ServerException ? e.message : e.toString()));
    }
  }
}
