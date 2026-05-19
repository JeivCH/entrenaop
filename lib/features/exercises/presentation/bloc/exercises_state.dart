import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();

  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {
  const ExerciseInitial();
}

class ExerciseLoading extends ExerciseState {
  const ExerciseLoading();
}

class ExercisesLoaded extends ExerciseState {
  final List<ExerciseEntity> exercises;

  const ExercisesLoaded({required this.exercises});

  @override
  List<Object?> get props => [exercises];
}

class ExerciseDetailLoaded extends ExerciseState {
  final ExerciseEntity exercise;

  const ExerciseDetailLoaded({required this.exercise});

  @override
  List<Object?> get props => [exercise];
}

class ExerciseOperationSuccess extends ExerciseState {
  const ExerciseOperationSuccess();
}

class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError({required this.message});

  @override
  List<Object?> get props => [message];
}
