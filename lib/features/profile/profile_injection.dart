import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/auth/domain/repository/user_auth_repository.dart';
import 'package:pulse/features/profile/data/repository/profile_repository_impl.dart';
import 'package:pulse/features/profile/domain/repository/profile_repository.dart';
import 'package:pulse/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:pulse/features/profile/domain/usecases/sign_out_use_case.dart';
import 'package:pulse/features/profile/domain/usecases/update_profile_picture_use_case.dart';
import 'package:pulse/features/profile/presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

void initProfileModule() {
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      sl<FirebaseFirestore>(),
      sl<FirebaseStorage>(),
    ),
  );

  sl.registerLazySingleton(() => SignOutUseCase(sl<UserAuthRepository>()));
  sl.registerLazySingleton(
    () => GetUserProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateProfilePictureUseCase(sl<ProfileRepository>()),
  );

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      sl<SignOutUseCase>(),
      sl<GetUserProfileUseCase>(),
      sl<UpdateProfilePictureUseCase>(),
      sl<GetCurrentUserIdUseCase>(),
      sl<Logger>(),
    ),
  );
}