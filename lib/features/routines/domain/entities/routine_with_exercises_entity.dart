import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/domain/entities/routine_exercise_entity.dart';
import 'package:equatable/equatable.dart';

class RoutineWithExercisesEntity extends Equatable {
  final RoutineEntity routine;
  final List<RoutineExerciseEntity> exercises;

  const RoutineWithExercisesEntity({
    required this.routine,
    required this.exercises,
  });

  @override
  List<Object?> get props => [routine, exercises];
}
