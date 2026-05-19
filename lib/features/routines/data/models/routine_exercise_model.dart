import 'package:entrenaop/features/exercises/data/models/exercise_model.dart';
import 'package:entrenaop/features/routines/domain/entities/routine_exercise_entity.dart';

class RoutineExerciseModel extends RoutineExerciseEntity {
  const RoutineExerciseModel({
    required super.routineId,
    required super.exerciseId,
    required super.orderIndex,
    super.sets,
    super.reps,
    super.durationSeconds,
    super.weightKg,
    super.restSeconds,
    super.notes,
    super.exercise,
  });

  factory RoutineExerciseModel.fromJson(Map<String, dynamic> json) {
    return RoutineExerciseModel(
      routineId: json['routine_id'],
      exerciseId: json['exercise_id'],
      orderIndex: json['order_index'] ?? 0,
      sets: json['sets'],
      reps: json['reps'],
      durationSeconds: json['duration_seconds'],
      weightKg: json['weight_kg'] != null
          ? (json['weight_kg'] as num).toDouble()
          : null,
      restSeconds: json['rest_seconds'],
      notes: json['notes'],
      exercise: json['exercises'] != null
          ? ExerciseModel.fromJson(json['exercises'])
          : null,
    );
  }
}
