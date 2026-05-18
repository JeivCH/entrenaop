import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:equatable/equatable.dart';

class ExerciseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExerciseInitial extends ExerciseState {}

class ExerciseLoading extends ExerciseState {}

class ExercisesLoaded extends ExerciseState {
  final List<ExerciseEntity> exercises;

  ExercisesLoaded({required this.exercises});

  @override
  List<Object?> get props => [exercises];
}
