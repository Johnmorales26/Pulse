import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:pulse/features/auth/data/repository/user_auth_repository_impl.dart';
import 'package:pulse/features/auth/domain/repository/user_auth_repository.dart';
import 'package:pulse/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:pulse/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:pulse/features/auth/presentation/auth_bloc.dart';

final sl = GetIt.instance;

void initAuthModule() {
  sl.registerLazySingleton<UserAuthRepository>(
    () => UserAuthRepositoryImpl(sl<FirebaseAuth>(), sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton(() => SignInUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(() => SignUpUseCase(sl<UserAuthRepository>()));

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      sl<SignInUseCase>(),
      sl<SignUpUseCase>(),
    ),
  );
}
