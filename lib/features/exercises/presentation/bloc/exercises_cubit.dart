// lib/features/exercises/presentation/bloc/exercises_cubit.dart
// Gestiona el estado de la lista de ejercicios.
// Por ahora solo carga todos — filtros por músculo los añadimos en la UI.

import 'package:entrenaop/core/errors/exceptions.dart';
import 'package:entrenaop/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/get_exercises_by_muscle_group_usecase.dart';
import 'package:entrenaop/features/exercises/presentation/bloc/exercises_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExercisesCubit extends Cubit<ExerciseState> {
  final GetExercisesUseCase getExercisesUseCase;
  final GetExercisesByMuscleGroupUseCase getExercisesByMuscleGroupUseCase;

  ExercisesCubit({
    required this.getExercisesUseCase,
    required this.getExercisesByMuscleGroupUseCase,
  }) : super(ExerciseInitial());

  // Carga todos los ejercicios públicos
  Future<void> loadExercises() async {
    emit(ExerciseLoading());
    try {
      final exercises = await getExercisesUseCase();
      emit(ExercisesLoaded(exercises: exercises));
    } catch (e) {
      if (e is ServerException) {
        emit(ExerciseError(message: e.message));
      } else {
        emit(ExerciseError(message: e.toString()));
      }
    }
  }

  // Filtra por grupo muscular
  Future<void> filterByMuscleGroup(String muscleGroup) async {
    emit(ExerciseLoading());
    try {
      final exercises = await getExercisesByMuscleGroupUseCase(muscleGroup);
      emit(ExercisesLoaded(exercises: exercises));
    } catch (e) {
      if (e is ServerException) {
        emit(ExerciseError(message: e.message));
      } else {
        emit(ExerciseError(message: e.toString()));
      }
    }
  }
}
