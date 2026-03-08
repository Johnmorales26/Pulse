import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/place_detail/domain/usecases/check_if_place_saved_use_case.dart';
import 'package:pulse/features/place_detail/domain/usecases/get_place_stream_use_case.dart';
import 'package:pulse/features/place_detail/domain/usecases/get_saved_places_use_case.dart';
import 'package:pulse/features/place_detail/domain/usecases/toggle_saved_place_use_case.dart';
import 'package:pulse/features/profile/presentation/bloc/saved_places_bloc.dart';
import 'data/repositories/place_repository_impl.dart';
import 'domain/repositories/place_repository.dart';
import 'domain/usecases/add_comment_use_case.dart';
import 'presentation/bloc/place_detail_bloc.dart';

final sl = GetIt.instance;

void initPlaceDetailModule() {
  sl.registerLazySingleton<PlaceRepository>(
    () => PlaceRepositoryImpl(
      sl<FirebaseFirestore>(),
      sl<GetCurrentUserIdUseCase>(),
    ),
  );

  sl.registerLazySingleton(() => AddCommentUseCase(sl<PlaceRepository>()));
  sl.registerLazySingleton(() => GetPlaceStreamUseCase(sl<PlaceRepository>()));
  sl.registerLazySingleton(
    () => CheckIfPlaceSavedUseCase(sl<PlaceRepository>()),
  );
  sl.registerLazySingleton(
    () => ToggleSavedPlaceUseCase(sl<PlaceRepository>()),
  );
  sl.registerLazySingleton(
    () => GetSavedPlacesUseCase(sl<PlaceRepository>()),
  );

  sl.registerFactory(
    () => SavedPlacesBloc(
      sl<GetSavedPlacesUseCase>(),
      sl<GetCurrentUserIdUseCase>(),
    ),
  );

  sl.registerFactory(
    () => PlaceDetailBloc(
      sl<AddCommentUseCase>(),
      sl<GetPlaceStreamUseCase>(),
      sl<CheckIfPlaceSavedUseCase>(),
      sl<ToggleSavedPlaceUseCase>(),
      sl<GetCurrentUserIdUseCase>(),
    ),
  );
}
