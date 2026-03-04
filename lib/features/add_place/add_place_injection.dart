import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'data/datasource/add_place_datasource.dart';
import 'data/repository/add_place_repository_impl.dart';
import 'domain/repository/add_place_repository.dart';
import 'domain/usecases/add_place_use_case.dart';
import 'presentation/bloc/add_place_bloc.dart';

final sl = GetIt.instance;

void initAddPlaceModule() {
  sl.registerLazySingleton<AddPlaceDatasource>(
    () => AddPlaceDatasource(
      sl<FirebaseFirestore>(),
      sl<GetCurrentUserIdUseCase>(),
    ),
  );

  sl.registerLazySingleton<AddPlaceRepository>(
    () => AddPlaceRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AddPlaceUseCase>(
    () => AddPlaceUseCase(sl()),
  );

  sl.registerFactory<AddPlaceBloc>(
    () => AddPlaceBloc(sl<AddPlaceUseCase>(), sl<GetCurrentUserIdUseCase>()),
  );
}
