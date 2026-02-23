import '../domain/model/place_location.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapSuccess extends MapState {
  final List<PlaceLocation> locations;
  final PlaceLocation? selectedLocation;

  MapSuccess({required this.locations, this.selectedLocation});

  MapSuccess copyWith({
    List<PlaceLocation>? locations,
    PlaceLocation? selectedLocation,
    bool clearSelection = false,
  }) {
    return MapSuccess(
      locations: locations ?? this.locations,
      selectedLocation: clearSelection
          ? null
          : (selectedLocation ?? this.selectedLocation),
    );
  }
}

class MapError extends MapState {
  final String error;

  MapError(this.error);
}
