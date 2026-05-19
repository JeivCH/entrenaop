import 'package:entrenaop/core/navigation/main_page.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_state.dart';
import 'package:entrenaop/features/auth/presentation/pages/home_page.dart';
import 'package:entrenaop/features/auth/presentation/pages/login_page.dart';
import 'package:entrenaop/features/auth/presentation/pages/profile_page.dart';
import 'package:entrenaop/features/auth/presentation/pages/sign_up_page.dart';
import 'package:entrenaop/features/exercises/presentation/pages/exercises_page.dart';
import 'package:entrenaop/features/routines/presentation/pages/routines_page.dart';
import 'package:entrenaop/features/session/presentation/pages/active_session_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;

  RouterNotifier(this._authCubit) {
    _authCubit.stream.listen((_) => notifyListeners());
  }
}

GoRouter createRouter(AuthCubit authCubit) {
  final notifier = RouterNotifier(authCubit);

  return GoRouter(
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = authCubit.state;
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoading = authState is AuthLoading || authState is AuthInitial;
      final loc = state.matchedLocation;

      if (isLoading) return null;

      final publicRoutes = ['/', '/signup'];
      final isOnPublicRoute = publicRoutes.contains(loc);

      if (!isAuthenticated && !isOnPublicRoute) return '/';
      if (isAuthenticated && isOnPublicRoute) return '/home';
      return null;
    },
    routes: [
      // ─── Auth ─────────────────────────────────────────────────────────
      GoRoute(path: '/', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/signup', builder: (_, __) => const SignUpPage()),

      // ─── Shell con bottom nav ──────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) =>
            MainPage(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomePage(),
          ),
          GoRoute(
            path: '/exercises',
            builder: (_, __) => const ExercisesPage(),
          ),
          GoRoute(
            path: '/routines',
            builder: (_, __) => const RoutinesPage(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfilePage(),
          ),
        ],
      ),

      // ─── Pantalla de sesión activa (sin bottom nav) ────────────────────
      GoRoute(
        path: '/session/:routineId',
        builder: (_, state) => ActiveSessionPage(
          routineId: state.pathParameters['routineId']!,
        ),
      ),
    ],
  );
}
