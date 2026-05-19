import 'package:entrenaop/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:entrenaop/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:entrenaop/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:entrenaop/features/auth/domain/repositories/auth_repository.dart';
import 'package:entrenaop/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:entrenaop/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:entrenaop/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:entrenaop/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:entrenaop/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:entrenaop/features/exercises/data/datasources/exercise_remote_datasource.dart';
import 'package:entrenaop/features/exercises/data/datasources/exercise_remote_datasource_impl.dart';
import 'package:entrenaop/features/exercises/data/repositories/exercise_repository_impl.dart';
import 'package:entrenaop/features/exercises/domain/repositories/exercise_repository.dart';
import 'package:entrenaop/features/exercises/domain/usecases/create_exercise_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/delete_exercise_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/get_exercise_by_id_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/get_exercises_by_muscle_group_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/get_exercises_usecase.dart';
import 'package:entrenaop/features/exercises/domain/usecases/update_exercise_usecase.dart';
import 'package:entrenaop/features/exercises/presentation/bloc/exercises_cubit.dart';
import 'package:entrenaop/features/routines/data/datasources/routine_remote_datasource.dart';
import 'package:entrenaop/features/routines/data/datasources/routine_remote_datasource_impl.dart';
import 'package:entrenaop/features/routines/data/repositories/routine_repository_impl.dart';
import 'package:entrenaop/features/routines/domain/repositories/routine_repository.dart';
import 'package:entrenaop/features/routines/domain/usecases/get_assigned_routines_usecase.dart';
import 'package:entrenaop/features/routines/domain/usecases/get_public_routines_usecase.dart';
import 'package:entrenaop/features/routines/domain/usecases/get_routine_with_exercises_usecase.dart';
import 'package:entrenaop/features/routines/domain/usecases/get_routines_by_user_usecase.dart';
import 'package:entrenaop/features/routines/presentation/bloc/routines_cubit.dart';
import 'package:entrenaop/features/session/data/datasources/session_remote_datasource.dart';
import 'package:entrenaop/features/session/data/datasources/session_remote_datasource_impl.dart';
import 'package:entrenaop/features/session/data/repositories/session_repository_impl.dart';
import 'package:entrenaop/features/session/domain/repositories/session_repository.dart';
import 'package:entrenaop/features/session/domain/usecases/create_session_log_usecase.dart';
import 'package:entrenaop/features/session/domain/usecases/get_session_logs_usecase.dart';
import 'package:entrenaop/features/session/presentation/bloc/active_session_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ─── Core ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => Supabase.instance.client);

  // ─── Auth ────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerFactory(() => AuthCubit(
        signInUseCase: sl(),
        signUpUseCase: sl(),
        signOutUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));

  // ─── Exercises ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<ExerciseRemoteDataSource>(
    () => ExerciseRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<ExerciseRepository>(
    () => ExerciseRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetExercisesUseCase(sl()));
  sl.registerLazySingleton(() => GetExercisesByMuscleGroupUseCase(sl()));
  sl.registerLazySingleton(() => GetExerciseByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateExerciseUseCase(sl()));
  sl.registerLazySingleton(() => UpdateExerciseUseCase(sl()));
  sl.registerLazySingleton(() => DeleteExerciseUseCase(sl()));
  sl.registerFactory(() => ExercisesCubit(
        getExercisesUseCase: sl(),
        getExercisesByMuscleGroupUseCase: sl(),
        getExerciseByIdUseCase: sl(),
        createExerciseUseCase: sl(),
        updateExerciseUseCase: sl(),
        deleteExerciseUseCase: sl(),
      ));

  // ─── Routines ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<RoutineRemoteDataSource>(
    () => RoutineRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<RoutineRepository>(
    () => RoutineRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetPublicRoutinesUseCase(sl()));
  sl.registerLazySingleton(() => GetRoutinesByUserUseCase(sl()));
  sl.registerLazySingleton(() => GetAssignedRoutinesUseCase(sl()));
  sl.registerLazySingleton(() => GetRoutineWithExercisesUseCase(sl()));
  sl.registerFactory(() => RoutinesCubit(
        getPublicRoutinesUseCase: sl(),
        getRoutinesByUserUseCase: sl(),
        getAssignedRoutinesUseCase: sl(),
        getRoutineWithExercisesUseCase: sl(),
      ));

  // ─── Sessions ────────────────────────────────────────────────────────────
  sl.registerLazySingleton<SessionRemoteDataSource>(
    () => SessionRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<SessionRepository>(
    () => SessionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => CreateSessionLogUseCase(sl()));
  sl.registerLazySingleton(() => GetSessionLogsUseCase(sl()));
  sl.registerFactory(() => ActiveSessionCubit(
        getRoutineWithExercisesUseCase: sl(),
        createSessionLogUseCase: sl(),
      ));
}
