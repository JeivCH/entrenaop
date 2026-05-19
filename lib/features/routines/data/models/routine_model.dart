import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';

class RoutineModel extends RoutineEntity {
  const RoutineModel({
    required super.id,
    required super.name,
    super.description,
    super.thumbnailUrl,
    required super.routineType,
    required super.workoutType,
    required super.difficulty,
    super.estimatedDurationMin,
    required super.isPublic,
    required super.requiresPremium,
    required super.createdBy,
    super.assignedTo,
  });

  factory RoutineModel.fromJson(Map<String, dynamic> json) {
    return RoutineModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      routineType: json['routine_type'] ?? 'public',
      workoutType: json['workout_type'] ?? 'strength',
      difficulty: json['difficulty'] ?? 'principiante',
      estimatedDurationMin: json['estimated_duration_min'],
      isPublic: json['is_public'] ?? false,
      requiresPremium: json['requires_premium'] ?? false,
      createdBy: json['created_by'],
      assignedTo: json['assigned_to'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'routine_type': routineType,
      'workout_type': workoutType,
      'difficulty': difficulty,
      'estimated_duration_min': estimatedDurationMin,
      'is_public': isPublic,
      'requires_premium': requiresPremium,
      'created_by': createdBy,
      'assigned_to': assignedTo,
    };
  }
}
