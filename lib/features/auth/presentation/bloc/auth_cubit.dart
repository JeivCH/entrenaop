import 'package:entrenaop/core/errors/exceptions.dart';
import 'package:entrenaop/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:entrenaop/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:entrenaop/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  Future<void> signIn({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase(email: email, password: password);
      emit(AuthAuthenticated(user: user));
    } catch (e) {
      if (e is ServerException) {
        emit(AuthError(message: e.message));
      } else {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await signOutUseCase();
      emit(AuthUnauthenticated());
    } catch (e) {
      if (e is ServerException) {
        emit(AuthError(message: e.message));
      } else {
        emit(AuthError(message: e.toString()));
      }
    }
  }

  Future<void> checkCurrentUser() async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      if (e is ServerException) {
        emit(AuthError(message: e.message));
      } else {
        emit(AuthError(message: e.toString()));
      }
    }
  }
}
