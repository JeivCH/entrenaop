import 'package:entrenaop/core/errors/exceptions.dart';
import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:entrenaop/features/exercises/domain/usecases/create_exercise_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/delete_exercise_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/get_exercise_by_id_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/get_exercises_by_muscle_group_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/update_exercise_usecase.dart';
import 'package:entrenaop/features/exercises/presentation/bloc/exercises_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExercisesCubit extends Cubit<ExerciseState> {
  final GetExercisesUseCase getExercisesUseCase;
  final GetExercisesByMuscleGroupUseCase getExercisesByMuscleGroupUseCase;
  final GetExerciseByIdUseCase getExerciseByIdUseCase;
  final CreateExerciseUseCase createExerciseUseCase;
  final UpdateExerciseUseCase updateExerciseUseCase;
  final DeleteExerciseUseCase deleteExerciseUseCase;

  ExercisesCubit({
    required this.getExercisesUseCase,
    required this.getExercisesByMuscleGroupUseCase,
    required this.getExerciseByIdUseCase,
    required this.createExerciseUseCase,
    required this.updateExerciseUseCase,
    required this.deleteExerciseUseCase,
  }) : super(const ExerciseInitial());

  Future<void> loadExercises() async {
    emit(const ExerciseLoading());
    try {
      final exercises = await getExercisesUseCase();
      emit(ExercisesLoaded(exercises: exercises));
    } catch (e) {
      emit(ExerciseError(message: e is ServerException ? e.message : e.toString()));
    }
  }

  Future<void> loadExercisesByMuscleGroup(String muscleGroup) async {
    emit(const ExerciseLoading());
    try {
      final exercises = await getExercisesByMuscleGroupUseCase(muscleGroup);
      emit(ExercisesLoaded(exercises: exercises));
    } catch (e) {
      emit(ExerciseError(message: e is ServerException ? e.message : e.toString()));
    }
  }

  Future<void> loadExerciseById(String id) async {
    emit(const ExerciseLoading());
    try {
      final exercise = await getExerciseByIdUseCase(id);
      if (exercise != null) {
        emit(ExerciseDetailLoaded(exercise: exercise));
      } else {
        emit(const ExerciseError(message: 'Ejercicio no encontrado'));
      }
    } catch (e) {
      emit(ExerciseError(message: e is ServerException ? e.message : e.toString()));
    }
  }

  Future<void> createExercise(ExerciseEntity exercise) async {
    emit(const ExerciseLoading());
    try {
      await createExerciseUseCase(exercise);
      emit(const ExerciseOperationSuccess());
      await loadExercises();
    } catch (e) {
      emit(ExerciseError(message: e is ServerException ? e.message : e.toString()));
    }
  }

  Future<void> updateExercise(ExerciseEntity exercise) async {
    emit(const ExerciseLoading());
    try {
      await updateExerciseUseCase(exercise);
      emit(const ExerciseOperationSuccess());
      await loadExercises();
    } catch (e) {
      emit(ExerciseError(message: e is ServerException ? e.message : e.toString()));
    }
  }

  Future<void> deleteExercise(String id) async {
    emit(const ExerciseLoading());
    try {
      await deleteExerciseUseCase(id);
      emit(const ExerciseOperationSuccess());
      await loadExercises();
    } catch (e) {
      emit(ExerciseError(message: e is ServerException ? e.message : e.toString()));
    }
  }
}
