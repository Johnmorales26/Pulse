import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../domain/usecases/get_map_location_use_case.dart';
import 'map_intent.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapIntent, MapState> {
  final GetMapLocationsUseCase getMapLocationsUseCase;
  final Logger logger;

  MapBloc(this.getMapLocationsUseCase, this.logger) : super(MapInitial()) {
    on<FetchMapLocationsIntent>(_onFetchLocations);
  }

  Future<void> _onFetchLocations(FetchMapLocationsIntent intent, Emitter<MapState> emit) async {
    emit(MapLoading());
    try {
      final locations = await getMapLocationsUseCase();

      emit(MapSuccess(locations));
    } catch (e) {
      logger.d('Log de Manager -> Error crítico al consultar Firebase: $e');
      emit(MapError(e.toString()));
    }
  }
}