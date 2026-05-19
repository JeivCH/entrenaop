import 'package:entrenaop/features/session/domain/entities/session_log_entity.dart';

class SessionLogModel extends SessionLogEntity {
  const SessionLogModel({
    super.id,
    required super.userId,
    required super.routineId,
    required super.completedAt,
    super.durationMin,
    required super.completed,
    super.rpe,
    super.mood,
    super.notes,
    super.externalSource,
  });

  factory SessionLogModel.fromJson(Map<String, dynamic> json) {
    return SessionLogModel(
      id: json['id'],
      userId: json['user_id'],
      routineId: json['routine_id'],
      completedAt: DateTime.parse(json['completed_at']),
      durationMin: json['duration_min'],
      completed: json['completed'] ?? false,
      rpe: json['rpe'],
      mood: json['mood'],
      notes: json['notes'],
      externalSource: json['external_source'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'routine_id': routineId,
      'completed_at': completedAt.toIso8601String(),
      'duration_min': durationMin,
      'completed': completed,
      'rpe': rpe,
      'mood': mood,
      'notes': notes,
      'external_source': externalSource,
    };
  }
}
