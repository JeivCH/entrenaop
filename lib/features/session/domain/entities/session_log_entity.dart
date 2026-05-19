import 'package:equatable/equatable.dart';

class SessionLogEntity extends Equatable {
  final String? id;
  final String userId;
  final String routineId;
  final DateTime completedAt;
  final int? durationMin;
  final bool completed;
  final int? rpe; // 1-10
  final String? mood; // great, good, okay, bad
  final String? notes;
  final String? externalSource; // garmin, strava, null

  const SessionLogEntity({
    this.id,
    required this.userId,
    required this.routineId,
    required this.completedAt,
    this.durationMin,
    required this.completed,
    this.rpe,
    this.mood,
    this.notes,
    this.externalSource,
  });

  @override
  List<Object?> get props => [
        id, userId, routineId, completedAt, durationMin,
        completed, rpe, mood, notes, externalSource,
      ];
}
