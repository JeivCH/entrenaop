import 'package:entrenaop/core/di/injection_container.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_state.dart';
import 'package:entrenaop/features/session/presentation/bloc/active_session_cubit.dart';
import 'package:entrenaop/features/session/presentation/bloc/active_session_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ActiveSessionPage extends StatelessWidget {
  final String routineId;

  const ActiveSessionPage({super.key, required this.routineId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ActiveSessionCubit>()..startSession(routineId),
      child: const _ActiveSessionView(),
    );
  }
}

class _ActiveSessionView extends StatelessWidget {
  const _ActiveSessionView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ActiveSessionCubit, ActiveSessionState>(
      listener: (context, state) {
        if (state is ActiveSessionCompleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Sesión guardada!'),
              backgroundColor: Color(0xFFE65100),
            ),
          );
          context.go('/home');
        }
      },
      builder: (context, state) {
        if (state is ActiveSessionLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFF0A0A0A),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFE65100)),
            ),
          );
        }
        if (state is ActiveSessionError) {
          return Scaffold(
            backgroundColor: const Color(0xFF0A0A0A),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.white38, size: 48),
                  const SizedBox(height: 12),
                  Text(state.message,
                      style: const TextStyle(color: Colors.white38)),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/routines'),
                    child: const Text('Volver',
                        style: TextStyle(color: Color(0xFFE65100))),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is ActiveSessionRunning) {
          return _RunningView(state: state);
        }
        if (state is ActiveSessionFeedback) {
          return _FeedbackView(state: state);
        }
        return const Scaffold(backgroundColor: Color(0xFF0A0A0A));
      },
    );
  }
}

// ─── Vista principal de sesión activa ────────────────────────────────────────

class _RunningView extends StatelessWidget {
  final ActiveSessionRunning state;

  const _RunningView({required this.state});

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final exercise = state.currentExercise;
    final exerciseName = exercise.exercise?.name ?? 'Ejercicio';
    final muscleGroups = exercise.exercise?.muscleGroups ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior: progreso + cerrar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.routineData.routine.name,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (state.currentExerciseIndex + 1) /
                                state.totalExercises,
                            backgroundColor: Colors.white12,
                            color: const Color(0xFFE65100),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ejercicio ${state.currentExerciseIndex + 1} de ${state.totalExercises}',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _formatTime(state.elapsedSeconds),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _confirmExit(context),
                    child: const Icon(Icons.close, color: Colors.white38, size: 22),
                  ),
                ],
              ),
            ),

            Expanded(
              child: state.isResting
                  ? _RestView(
                      seconds: state.restSecondsRemaining,
                      onSkip: () =>
                          context.read<ActiveSessionCubit>().skipRest(),
                    )
                  : _ExerciseView(
                      exerciseName: exerciseName,
                      muscleGroups: muscleGroups,
                      currentSet: state.currentSet,
                      totalSets: state.totalSets,
                      reps: exercise.reps,
                      durationSeconds: exercise.durationSeconds,
                      weightKg: exercise.weightKg,
                      notes: exercise.notes,
                      thumbnailUrl: exercise.exercise?.thumbnailUrl,
                      onComplete: () =>
                          context.read<ActiveSessionCubit>().completeSet(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text('¿Abandonar sesión?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Se perderá el progreso de esta sesión.',
          style: TextStyle(color: Colors.white54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuar',
                style: TextStyle(color: Color(0xFFE65100))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/routines');
            },
            child: const Text('Salir',
                style: TextStyle(color: Colors.white38)),
          ),
        ],
      ),
    );
  }
}

class _ExerciseView extends StatelessWidget {
  final String exerciseName;
  final List<String> muscleGroups;
  final int currentSet;
  final int totalSets;
  final int? reps;
  final int? durationSeconds;
  final double? weightKg;
  final String? notes;
  final String? thumbnailUrl;
  final VoidCallback onComplete;

  const _ExerciseView({
    required this.exerciseName,
    required this.muscleGroups,
    required this.currentSet,
    required this.totalSets,
    this.reps,
    this.durationSeconds,
    this.weightKg,
    this.notes,
    this.thumbnailUrl,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),

          // Thumbnail / placeholder
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: thumbnailUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(thumbnailUrl!, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _ExercisePlaceholder()),
                  )
                : const _ExercisePlaceholder(),
          ),
          const SizedBox(height: 32),

          // Nombre del ejercicio
          Text(
            exerciseName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          if (muscleGroups.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              muscleGroups.take(3).join(' · '),
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 32),

          // Serie actual
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatBox(
                label: 'SERIE',
                value: '$currentSet / $totalSets',
                highlight: true,
              ),
              if (reps != null) ...[
                const SizedBox(width: 12),
                _StatBox(label: 'REPS', value: '$reps'),
              ],
              if (durationSeconds != null) ...[
                const SizedBox(width: 12),
                _StatBox(label: 'TIEMPO', value: '${durationSeconds}s'),
              ],
              if (weightKg != null) ...[
                const SizedBox(width: 12),
                _StatBox(label: 'PESO', value: '${weightKg}kg'),
              ],
            ],
          ),

          if (notes != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: Colors.white38, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      notes!,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const Spacer(),

          // Botón completar serie
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE65100),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                currentSet < totalSets ? 'Serie completada' : 'Ejercicio completado',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _RestView extends StatelessWidget {
  final int seconds;
  final VoidCallback onSkip;

  const _RestView({required this.seconds, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'DESCANSA',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '${seconds}s',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 80,
              fontWeight: FontWeight.w800,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Siguiente serie en breve',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.35),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 48),
          TextButton(
            onPressed: onSkip,
            child: const Text(
              'Saltar descanso',
              style: TextStyle(color: Color(0xFFE65100), fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExercisePlaceholder extends StatelessWidget {
  const _ExercisePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.fitness_center, color: Colors.white24, size: 48),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _StatBox({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFFE65100).withValues(alpha: 0.15)
            : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight
              ? const Color(0xFFE65100).withValues(alpha: 0.4)
              : Colors.white12,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: highlight ? const Color(0xFFE65100) : Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Pantalla de feedback post-sesión ────────────────────────────────────────

class _FeedbackView extends StatefulWidget {
  final ActiveSessionFeedback state;

  const _FeedbackView({required this.state});

  @override
  State<_FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<_FeedbackView> {
  int _rpe = 7;
  String _mood = 'good';
  final _notesController = TextEditingController();

  final _moods = [
    (value: 'great', emoji: '💪', label: 'Genial'),
    (value: 'good', emoji: '😊', label: 'Bien'),
    (value: 'okay', emoji: '😐', label: 'Regular'),
    (value: 'bad', emoji: '😓', label: 'Mal'),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : '';

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text('🎯', style: TextStyle(fontSize: 56)),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  '¡Sesión completada!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Center(
                child: Text(
                  '${widget.state.durationMin} min · ${widget.state.routineData.routine.name}',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                ),
              ),
              const SizedBox(height: 40),

              // RPE
              const Text(
                'Esfuerzo percibido (RPE)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                '1 = muy fácil · 10 = al límite',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35), fontSize: 12),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(10, (i) {
                  final v = i + 1;
                  final isSelected = _rpe == v;
                  return GestureDetector(
                    onTap: () => setState(() => _rpe = v),
                    child: Container(
                      width: 30,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFE65100)
                            : const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFE65100)
                              : Colors.white12,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$v',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white54,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),

              // Mood
              const Text(
                '¿Cómo te has sentido?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: _moods.map((m) {
                  final isSelected = _mood == m.value;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _mood = m.value),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFE65100).withValues(alpha: 0.15)
                              : const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFE65100)
                                : Colors.white12,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(m.emoji,
                                style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text(
                              m.label,
                              style: TextStyle(
                                color: isSelected
                                    ? const Color(0xFFE65100)
                                    : Colors.white38,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Notas
              const Text(
                'Notas (opcional)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: '¿Algo que destacar de esta sesión?',
                  hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.3), fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFFE65100), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
              const SizedBox(height: 32),

              // Guardar
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ActiveSessionCubit>().finishSession(
                          userId: userId,
                          durationMin: widget.state.durationMin,
                          rpe: _rpe,
                          mood: _mood,
                          notes: _notesController.text.trim().isNotEmpty
                              ? _notesController.text.trim()
                              : null,
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE65100),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Guardar sesión',
                    style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
