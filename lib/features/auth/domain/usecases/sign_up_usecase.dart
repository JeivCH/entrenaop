import 'package:entrenaop/features/auth/domain/entities/user_entity.dart';
import 'package:entrenaop/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return await repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }
}
