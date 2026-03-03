import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:pulse/features/place_detail/domain/usecases/get_place_stream_use_case.dart';
import 'data/repositories/place_repository_impl.dart';
import 'domain/repositories/place_repository.dart';
import 'domain/usecases/add_comment_use_case.dart';
import 'presentation/bloc/place_detail_bloc.dart';

final sl = GetIt.instance;

void initPlaceDetailModule() {
  // Repositorio
  sl.registerLazySingleton<PlaceRepository>(
    () => PlaceRepositoryImpl(sl<FirebaseFirestore>(), sl<Logger>()),
  );

  // Casos de Uso
  sl.registerLazySingleton(() => AddCommentUseCase(sl<PlaceRepository>()));
  sl.registerLazySingleton(() => GetPlaceStreamUseCase(sl<PlaceRepository>()));

  // BLoC
  sl.registerFactory(
    () => PlaceDetailBloc(sl<AddCommentUseCase>(), sl<GetPlaceStreamUseCase>()),
  );
}
