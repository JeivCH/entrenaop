import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:equatable/equatable.dart';

class RoutineExerciseEntity extends Equatable {
  final String routineId;
  final String exerciseId;
  final int orderIndex;
  final int? sets;
  final int? reps;
  final int? durationSeconds;
  final double? weightKg;
  final int? restSeconds;
  final String? notes;
  final ExerciseEntity? exercise; // populated in joined queries

  const RoutineExerciseEntity({
    required this.routineId,
    required this.exerciseId,
    required this.orderIndex,
    this.sets,
    this.reps,
    this.durationSeconds,
    this.weightKg,
    this.restSeconds,
    this.notes,
    this.exercise,
  });

  @override
  List<Object?> get props => [
        routineId, exerciseId, orderIndex, sets, reps,
        durationSeconds, weightKg, restSeconds, notes,
      ];
}
