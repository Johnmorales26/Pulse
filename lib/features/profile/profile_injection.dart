import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:pulse/features/auth/domain/repository/user_auth_repository.dart';
import 'package:pulse/features/profile/domain/usecases/sign_out_use_case.dart';
import 'package:pulse/features/profile/presentation/profile_bloc.dart';

final sl = GetIt.instance;

void initProfileModule() {
  sl.registerLazySingleton(() => SignOutUseCase(sl<UserAuthRepository>()));

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(sl<SignOutUseCase>(), sl<Logger>()),
  );
}