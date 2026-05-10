// features/auth/data/datasources/auth_remote_datasource.dart
import 'package:entrenaop/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Inicia sesión con email y contraseña.
  /// Lanza [ServerException] si las credenciales son incorrectas.
  Future<UserModel> signIn({required String email, required String password});

  /// Cierra la sesión del usuario actual.
  Future<void> signOut();

  /// Devuelve el [UserModel] del usuario autenticado, o null si no hay sesión activa.
  Future<UserModel?> getCurrentUser();
}
