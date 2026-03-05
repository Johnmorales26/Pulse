import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/web.dart';
import 'package:pulse/core/auth/data/repository/auth_repository_impl.dart';
import 'package:pulse/core/auth/domain/repository/auth_repository.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/map/data/datasource/firebase_location_data_source.dart';
import 'package:pulse/features/map/data/datasource/location_data_source.dart';
import 'package:pulse/features/map/data/repository/location_device_repository_impl.dart';
import 'package:pulse/features/map/data/repository/place_location_repository_impl.dart';
import 'package:pulse/features/map/domain/repository/location_device_repository.dart';
import 'package:pulse/features/map/domain/repository/place_location_repository.dart';
import 'package:pulse/features/map/domain/usecases/get_map_location_use_case.dart';
import 'package:pulse/core/utils/launch_map_use_case.dart';
import 'package:pulse/features/map/domain/usecases/get_user_location_use_case.dart';
import 'package:pulse/features/map/presentation/map_bloc.dart';
import 'package:pulse/features/add_place/add_place_injection.dart';
import 'package:pulse/features/auth/auth_injection.dart';
import 'package:pulse/features/place_detail/place_detail_injection.dart';
import 'package:pulse/features/profile/profile_injection.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<Logger>(
    () => Logger(
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
        colors: true,
        printEmojis: true,
      ),
    ),
  );

  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton(() => GetCurrentUserIdUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => const LaunchMapUseCase());

  sl.registerLazySingleton<FirebaseLocationDataSource>(
    () => FirebaseLocationDataSource(sl()),
  );

  sl.registerLazySingleton<LocationDataSource>(() => LocationDataSource());

  sl.registerLazySingleton<PlaceLocationRepository>(
    () => PlaceLocationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<LocationDeviceRepository>(
    () => LocationDeviceRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetMapLocationsUseCase>(
    () => GetMapLocationsUseCase(sl()),
  );

  sl.registerLazySingleton<GetUserLocationUseCase>(
    () => GetUserLocationUseCase(sl()),
  );

  sl.registerFactory<MapBloc>(() => MapBloc(sl(), sl(), sl()));

  initPlaceDetailModule();
  initAddPlaceModule();
  initAuthModule();
  initProfileModule();
}
