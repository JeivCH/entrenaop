import 'package:equatable/equatable.dart';

class RoutineEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? thumbnailUrl;
  final String routineType; // public, assigned, custom
  final String workoutType; // strength, cardio, amrap, emom, tabata, opos
  final String difficulty;
  final int? estimatedDurationMin;
  final bool isPublic;
  final bool requiresPremium;
  final String createdBy;
  final String? assignedTo;

  const RoutineEntity({
    required this.id,
    required this.name,
    this.description,
    this.thumbnailUrl,
    required this.routineType,
    required this.workoutType,
    required this.difficulty,
    this.estimatedDurationMin,
    required this.isPublic,
    required this.requiresPremium,
    required this.createdBy,
    this.assignedTo,
  });

  @override
  List<Object?> get props => [
        id, name, description, thumbnailUrl, routineType, workoutType,
        difficulty, estimatedDurationMin, isPublic, requiresPremium,
        createdBy, assignedTo,
      ];
}
