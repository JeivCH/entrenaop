import 'package:entrenaop/core/di/injection_container.dart';
import 'package:entrenaop/features/exercises/domain/entities/exercise_entity.dart';
import 'package:entrenaop/features/exercises/presentation/bloc/exercises_state.dart';
import 'package:entrenaop/features/exercises/presentation/bloc/exercises_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExercisesPage extends StatelessWidget {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExercisesCubit>()..loadExercises(),
      child: const _ExercisesView(),
    );
  }
}

class _ExercisesView extends StatefulWidget {
  const _ExercisesView();

  @override
  State<_ExercisesView> createState() => _ExercisesViewState();
}

class _ExercisesViewState extends State<_ExercisesView> {
  String? _selectedMuscle;

  static const _muscleGroups = [
    'Todos', 'pectoral', 'espalda', 'piernas', 'hombros',
    'bíceps', 'tríceps', 'core', 'glúteos', 'cardio',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                'Ejercicios',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filtros por músculo
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _muscleGroups.length,
                itemBuilder: (context, i) {
                  final muscle = _muscleGroups[i];
                  final isSelected = (muscle == 'Todos' && _selectedMuscle == null) ||
                      muscle == _selectedMuscle;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMuscle = muscle == 'Todos' ? null : muscle;
                        });
                        final cubit = context.read<ExercisesCubit>();
                        if (muscle == 'Todos') {
                          cubit.loadExercises();
                        } else {
                          cubit.loadExercisesByMuscleGroup(muscle);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE65100)
                              : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE65100)
                                : Colors.white12,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          muscle,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white60,
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Lista de ejercicios
            Expanded(
              child: BlocBuilder<ExercisesCubit, ExerciseState>(
                builder: (context, state) {
                  if (state is ExerciseLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFFE65100)),
                    );
                  }
                  if (state is ExerciseError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.white38, size: 48),
                          const SizedBox(height: 12),
                          Text(state.message,
                              style: const TextStyle(color: Colors.white38)),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () =>
                                context.read<ExercisesCubit>().loadExercises(),
                            child: const Text('Reintentar',
                                style: TextStyle(color: Color(0xFFE65100))),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is ExercisesLoaded) {
                    if (state.exercises.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.fitness_center_outlined,
                                color: Colors.white24, size: 56),
                            const SizedBox(height: 16),
                            Text(
                              'No hay ejercicios todavía',
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: const Color(0xFFE65100),
                      backgroundColor: const Color(0xFF1A1A1A),
                      onRefresh: () =>
                          context.read<ExercisesCubit>().loadExercises(),
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: state.exercises.length,
                        itemBuilder: (context, i) =>
                            _ExerciseCard(exercise: state.exercises[i]),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseCard extends StatelessWidget {
  final ExerciseEntity exercise;

  const _ExerciseCard({required this.exercise});

  Color _difficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'principiante':
        return Colors.green;
      case 'intermedio':
        return const Color(0xFFE65100);
      case 'avanzado':
        return Colors.red;
      default:
        return Colors.white38;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        children: [
          // Thumbnail / icono
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: exercise.thumbnailUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      exercise.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.fitness_center,
                        color: Colors.white24,
                        size: 24,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.fitness_center,
                    color: Colors.white24,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (exercise.muscleGroups.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    exercise.muscleGroups.take(3).join(' · '),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _difficultyColor(exercise.difficulty)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        exercise.difficulty,
                        style: TextStyle(
                          color: _difficultyColor(exercise.difficulty),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        exercise.exerciseType,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.white24, size: 20),
        ],
      ),
    );
  }
}
