import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/place_detail/domain/usecases/get_place_stream_use_case.dart';
import 'data/repositories/place_repository_impl.dart';
import 'domain/repositories/place_repository.dart';
import 'domain/usecases/add_comment_use_case.dart';
import 'presentation/bloc/place_detail_bloc.dart';

final sl = GetIt.instance;

void initPlaceDetailModule() {
  sl.registerLazySingleton<PlaceRepository>(
    () => PlaceRepositoryImpl(
      sl<FirebaseFirestore>(),
      sl<Logger>(),
      sl<GetCurrentUserIdUseCase>(),
    ),
  );

  sl.registerLazySingleton(() => AddCommentUseCase(sl<PlaceRepository>()));
  sl.registerLazySingleton(() => GetPlaceStreamUseCase(sl<PlaceRepository>()));

  sl.registerFactory(
    () => PlaceDetailBloc(
      sl<AddCommentUseCase>(),
      sl<GetPlaceStreamUseCase>(),
      sl<GetCurrentUserIdUseCase>(),
    ),
  );
}
