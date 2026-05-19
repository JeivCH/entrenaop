import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/domain/entities/routine_with_exercises_entity.dart';
import 'package:equatable/equatable.dart';

abstract class RoutineState extends Equatable {
  const RoutineState();

  @override
  List<Object?> get props => [];
}

class RoutineInitial extends RoutineState {
  const RoutineInitial();
}

class RoutineLoading extends RoutineState {
  const RoutineLoading();
}

class RoutinesLoaded extends RoutineState {
  final List<RoutineEntity> routines;

  const RoutinesLoaded({required this.routines});

  @override
  List<Object?> get props => [routines];
}

class RoutineDetailLoaded extends RoutineState {
  final RoutineWithExercisesEntity routineWithExercises;

  const RoutineDetailLoaded({required this.routineWithExercises});

  @override
  List<Object?> get props => [routineWithExercises];
}

class RoutineOperationSuccess extends RoutineState {
  const RoutineOperationSuccess();
}

class RoutineError extends RoutineState {
  final String message;

  const RoutineError({required this.message});

  @override
  List<Object?> get props => [message];
}
