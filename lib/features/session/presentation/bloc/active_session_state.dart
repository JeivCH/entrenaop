import 'package:entrenaop/features/routines/domain/entities/routine_exercise_entity.dart';
import 'package:entrenaop/features/routines/domain/entities/routine_with_exercises_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ActiveSessionState extends Equatable {
  const ActiveSessionState();

  @override
  List<Object?> get props => [];
}

class ActiveSessionInitial extends ActiveSessionState {
  const ActiveSessionInitial();
}

class ActiveSessionLoading extends ActiveSessionState {
  const ActiveSessionLoading();
}

/// Sesión en curso
class ActiveSessionRunning extends ActiveSessionState {
  final RoutineWithExercisesEntity routineData;
  final int currentExerciseIndex;
  final int currentSet;
  final bool isResting;
  final int restSecondsRemaining;
  final int elapsedSeconds; // tiempo total de sesión

  const ActiveSessionRunning({
    required this.routineData,
    required this.currentExerciseIndex,
    required this.currentSet,
    required this.isResting,
    required this.restSecondsRemaining,
    required this.elapsedSeconds,
  });

  RoutineExerciseEntity get currentExercise =>
      routineData.exercises[currentExerciseIndex];

  int get totalExercises => routineData.exercises.length;
  int get totalSets => currentExercise.sets ?? 1;

  ActiveSessionRunning copyWith({
    int? currentExerciseIndex,
    int? currentSet,
    bool? isResting,
    int? restSecondsRemaining,
    int? elapsedSeconds,
  }) {
    return ActiveSessionRunning(
      routineData: routineData,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      currentSet: currentSet ?? this.currentSet,
      isResting: isResting ?? this.isResting,
      restSecondsRemaining: restSecondsRemaining ?? this.restSecondsRemaining,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
    );
  }

  @override
  List<Object?> get props => [
        routineData, currentExerciseIndex, currentSet,
        isResting, restSecondsRemaining, elapsedSeconds,
      ];
}

/// Sesión terminada — esperando RPE y mood del usuario
class ActiveSessionFeedback extends ActiveSessionState {
  final RoutineWithExercisesEntity routineData;
  final int durationMin;

  const ActiveSessionFeedback({
    required this.routineData,
    required this.durationMin,
  });

  @override
  List<Object?> get props => [routineData, durationMin];
}

/// Sesión guardada correctamente
class ActiveSessionCompleted extends ActiveSessionState {
  const ActiveSessionCompleted();
}

class ActiveSessionError extends ActiveSessionState {
  final String message;

  const ActiveSessionError({required this.message});

  @override
  List<Object?> get props => [message];
}
