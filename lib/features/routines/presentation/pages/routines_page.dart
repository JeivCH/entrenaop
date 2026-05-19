import 'package:entrenaop/core/di/injection_container.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_state.dart';
import 'package:entrenaop/features/routines/domain/entities/routine_entity.dart';
import 'package:entrenaop/features/routines/presentation/bloc/routines_state.dart';
import 'package:entrenaop/features/routines/presentation/bloc/routines_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoutinesPage extends StatelessWidget {
  const RoutinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RoutinesCubit>()..loadPublicRoutines(),
      child: const _RoutinesView(),
    );
  }
}

class _RoutinesView extends StatefulWidget {
  const _RoutinesView();

  @override
  State<_RoutinesView> createState() => _RoutinesViewState();
}

class _RoutinesViewState extends State<_RoutinesView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : null;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: const Text(
                'Rutinas',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap: (i) {
                    final cubit = context.read<RoutinesCubit>();
                    if (i == 0) {
                      cubit.loadPublicRoutines();
                    } else if (userId != null) {
                      cubit.loadUserRoutines(userId);
                    }
                  },
                  indicator: BoxDecoration(
                    color: const Color(0xFFE65100),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white38,
                  labelStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  unselectedLabelStyle:
                      const TextStyle(fontSize: 13),
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Lobby'),
                    Tab(text: 'Mis rutinas'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: BlocBuilder<RoutinesCubit, RoutineState>(
                builder: (context, state) {
                  if (state is RoutineLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: Color(0xFFE65100)),
                    );
                  }
                  if (state is RoutineError) {
                    return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.white38)),
                    );
                  }
                  if (state is RoutinesLoaded) {
                    if (state.routines.isEmpty) {
                      return Center(
                        child: Text(
                          'No hay rutinas disponibles',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 16),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: state.routines.length,
                      itemBuilder: (context, i) => _RoutineCard(
                        routine: state.routines[i],
                        onTap: () => context
                            .push('/session/${state.routines[i].id}'),
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

class _RoutineCard extends StatelessWidget {
  final RoutineEntity routine;
  final VoidCallback onTap;

  const _RoutineCard({required this.routine, required this.onTap});

  IconData _workoutIcon(String type) {
    switch (type) {
      case 'cardio':
        return Icons.directions_run;
      case 'amrap':
      case 'emom':
      case 'tabata':
        return Icons.timer_outlined;
      case 'opos':
        return Icons.military_tech_outlined;
      default:
        return Icons.fitness_center;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFE65100).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _workoutIcon(routine.workoutType),
                color: const Color(0xFFE65100),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routine.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (routine.description != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      routine.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _tag(routine.workoutType.toUpperCase(),
                          const Color(0xFFE65100)),
                      const SizedBox(width: 6),
                      _tag(routine.difficulty, Colors.white24),
                      if (routine.estimatedDurationMin != null) ...[
                        const SizedBox(width: 6),
                        _tag('${routine.estimatedDurationMin} min',
                            Colors.white24),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_circle_outline,
                color: Color(0xFFE65100), size: 28),
          ],
        ),
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color == const Color(0xFFE65100) ? color : Colors.white38,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
