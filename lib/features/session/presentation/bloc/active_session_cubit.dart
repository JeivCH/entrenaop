import 'dart:async';

import 'package:entrenaop/core/errors/exceptions.dart';
import 'package:entrenaop/features/routines/domain/usecases/get_routine_with_exercises_usecase.dart';
import 'package:entrenaop/features/session/domain/entities/session_log_entity.dart';
import 'package:entrenaop/features/session/domain/usecases/create_session_log_usecase.dart';
import 'package:entrenaop/features/session/presentation/bloc/active_session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiveSessionCubit extends Cubit<ActiveSessionState> {
  final GetRoutineWithExercisesUseCase getRoutineWithExercisesUseCase;
  final CreateSessionLogUseCase createSessionLogUseCase;

  Timer? _restTimer;
  Timer? _elapsedTimer;
  DateTime? _sessionStart;

  ActiveSessionCubit({
    required this.getRoutineWithExercisesUseCase,
    required this.createSessionLogUseCase,
  }) : super(const ActiveSessionInitial());

  Future<void> startSession(String routineId) async {
    emit(const ActiveSessionLoading());
    try {
      final routineData = await getRoutineWithExercisesUseCase(routineId);
      _sessionStart = DateTime.now();
      emit(ActiveSessionRunning(
        routineData: routineData,
        currentExerciseIndex: 0,
        currentSet: 1,
        isResting: false,
        restSecondsRemaining: 0,
        elapsedSeconds: 0,
      ));
      _startElapsedTimer();
    } catch (e) {
      emit(ActiveSessionError(
          message: e is ServerException ? e.message : e.toString()));
    }
  }

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is ActiveSessionRunning) {
        emit(current.copyWith(elapsedSeconds: current.elapsedSeconds + 1));
      }
    });
  }

  /// Marca la serie actual como completada y arranca el descanso si toca
  void completeSet() {
    final current = state;
    if (current is! ActiveSessionRunning) return;

    final exercise = current.currentExercise;
    final restSecs = exercise.restSeconds ?? 60;

    if (current.currentSet < (exercise.sets ?? 1)) {
      // Hay más series — iniciar descanso
      emit(current.copyWith(isResting: true, restSecondsRemaining: restSecs));
      _startRestTimer();
    } else {
      // Última serie del ejercicio — pasar al siguiente
      _advanceToNextExercise(current);
    }
  }

  void _startRestTimer() {
    _restTimer?.cancel();
    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = state;
      if (current is! ActiveSessionRunning || !current.isResting) return;

      if (current.restSecondsRemaining <= 1) {
        _restTimer?.cancel();
        emit(current.copyWith(
          isResting: false,
          restSecondsRemaining: 0,
          currentSet: current.currentSet + 1,
        ));
      } else {
        emit(current.copyWith(
            restSecondsRemaining: current.restSecondsRemaining - 1));
      }
    });
  }

  void skipRest() {
    final current = state;
    if (current is! ActiveSessionRunning || !current.isResting) return;
    _restTimer?.cancel();
    emit(current.copyWith(
      isResting: false,
      restSecondsRemaining: 0,
      currentSet: current.currentSet + 1,
    ));
  }

  void _advanceToNextExercise(ActiveSessionRunning current) {
    final nextIndex = current.currentExerciseIndex + 1;
    if (nextIndex >= current.totalExercises) {
      // Sesión terminada
      _elapsedTimer?.cancel();
      _restTimer?.cancel();
      final durationMin = (current.elapsedSeconds / 60).ceil();
      emit(ActiveSessionFeedback(
        routineData: current.routineData,
        durationMin: durationMin,
      ));
    } else {
      emit(current.copyWith(
        currentExerciseIndex: nextIndex,
        currentSet: 1,
        isResting: false,
        restSecondsRemaining: 0,
      ));
    }
  }

  Future<void> finishSession({
    required String userId,
    required int durationMin,
    required int rpe,
    required String mood,
    String? notes,
  }) async {
    final current = state;
    if (current is! ActiveSessionFeedback) return;

    try {
      final log = SessionLogEntity(
        userId: userId,
        routineId: current.routineData.routine.id,
        completedAt: DateTime.now(),
        durationMin: durationMin,
        completed: true,
        rpe: rpe,
        mood: mood,
        notes: notes,
      );
      await createSessionLogUseCase(log);
      emit(const ActiveSessionCompleted());
    } catch (e) {
      emit(ActiveSessionError(
          message: e is ServerException ? e.message : e.toString()));
    }
  }

  @override
  Future<void> close() {
    _restTimer?.cancel();
    _elapsedTimer?.cancel();
    return super.close();
  }
}
