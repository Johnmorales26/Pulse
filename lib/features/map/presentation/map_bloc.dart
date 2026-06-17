import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/features/map/domain/usecases/get_user_location_use_case.dart';

import '../domain/usecases/get_map_location_use_case.dart';
import 'map_intent.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapIntent, MapState> {
  final GetMapLocationsUseCase getMapLocationsUseCase;
  final GetUserLocationUseCase getUserLocationUseCase;

  MapBloc(this.getMapLocationsUseCase, this.getUserLocationUseCase)
    : super(MapInitial()) {
    on<FetchMapLocationsIntent>(_onFetchLocations);
    on<SelectMapLocationIntent>(_onSelectLocation);
    on<DeselectMapLocationIntent>(_onDeselectLocation);
    on<FetchUserLocationIntent>(_onFetchUserLocation);
    on<ToggleMapFilterIntent>(_onToggleFilter);
    on<ClearMapFiltersIntent>(_onClearFilters);
  }

  Future<void> _onFetchLocations(
    FetchMapLocationsIntent intent,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());
    try {
      final locations = await getMapLocationsUseCase();
      emit(MapSuccess(locations: locations));
      add(FetchUserLocationIntent());
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }

  void _onSelectLocation(
    SelectMapLocationIntent intent,
    Emitter<MapState> emit,
  ) {
    if (state is MapSuccess) {
      final currentState = state as MapSuccess;
      emit(currentState.copyWith(selectedLocation: intent.location));
    }
  }

  void _onDeselectLocation(
    DeselectMapLocationIntent intent,
    Emitter<MapState> emit,
  ) {
    if (state is MapSuccess) {
      final currentState = state as MapSuccess;
      emit(currentState.copyWith(clearSelection: true));
    }
  }

  Future<void> _onFetchUserLocation(
    FetchUserLocationIntent intent,
    Emitter<MapState> emit,
  ) async {
    if (state is MapSuccess) {
      final currentState = state as MapSuccess;
      try {
        final userLoc = await getUserLocationUseCase();
        emit(
          currentState.copyWith(
            userLocation: userLoc,
            lastLocationUpdate: DateTime.now(),
          ),
        );
      } catch (e) {
        // ignore: empty_catches
      }
    }
  }

  void _onToggleFilter(
    ToggleMapFilterIntent intent,
    Emitter<MapState> emit,
  ) {
    if (state is MapSuccess) {
      final currentState = state as MapSuccess;
      final updatedCategories = Set<String>.from(currentState.selectedCategories);
      if (updatedCategories.contains(intent.category)) {
        updatedCategories.remove(intent.category);
      } else {
        updatedCategories.add(intent.category);
      }
      emit(currentState.copyWith(selectedCategories: updatedCategories));
    }
  }

  void _onClearFilters(
    ClearMapFiltersIntent intent,
    Emitter<MapState> emit,
  ) {
    if (state is MapSuccess) {
      final currentState = state as MapSuccess;
      emit(currentState.copyWith(selectedCategories: {}));
    }
  }
}
