import 'package:entrenaop/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_state.dart';
import 'package:entrenaop/features/auth/presentation/pages/home_page.dart';
import 'package:entrenaop/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterNotifier extends ChangeNotifier {
  final AuthCubit _authCubit;

  RouterNotifier(this._authCubit) {
    _authCubit.stream.listen((_) {
      notifyListeners();
    });
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
      final goingToLogin = state.matchedLocation == '/';

      if (isLoading) return null;
      if (!isAuthenticated && !goingToLogin) return '/';
      if (isAuthenticated && goingToLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
  );
}
