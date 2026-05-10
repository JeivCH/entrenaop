import 'package:entrenaop/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:entrenaop/features/auth/domain/entities/user_entity.dart';
import 'package:entrenaop/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserEntity> signIn(
      {required String email, required String password}) async {
    return await remoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    return await remoteDataSource.signOut();
  }
}
