import 'package:entrenaop/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:entrenaop/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:entrenaop/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:entrenaop/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:entrenaop/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// GetIt es el contenedor de dependencias — sl viene de "service locator"
final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ── Supabase ──────────────────────────────────────────
  sl.registerLazySingleton(() => Supabase.instance.client);

  // ── Datasources ───────────────────────────────────────
  sl.registerLazySingleton(
      () => AuthRemoteDataSourceImpl(supabaseClient: sl()));

  // ── Repositories ─────────────────────────────────────
  sl.registerLazySingleton(() => AuthRepositoryImpl(remoteDataSource: sl()));
  // ── Use Cases ────────────────────────────────────────
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  // ── Cubits ───────────────────────────────────────────

  sl.registerFactory(() => AuthCubit(
        signInUseCase: sl(),
        signOutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));
}
