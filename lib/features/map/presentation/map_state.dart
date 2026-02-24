import 'package:pulse/features/map/domain/model/user_location.dart';

import '../domain/model/place_location.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapSuccess extends MapState {
  final List<PlaceLocation> locations;
  final PlaceLocation? selectedLocation;
  final UserLocation? userLocation;
  final DateTime? lastLocationUpdate;

  MapSuccess({
    required this.locations,
    this.selectedLocation,
    this.userLocation,
    this.lastLocationUpdate,
  });

  MapSuccess copyWith({
    List<PlaceLocation>? locations,
    PlaceLocation? selectedLocation,
    UserLocation? userLocation,
    bool clearSelection = false,
    DateTime? lastLocationUpdate,
  }) {
    return MapSuccess(
      locations: locations ?? this.locations,
      selectedLocation: clearSelection
          ? null
          : (selectedLocation ?? this.selectedLocation),
      userLocation: userLocation ?? this.userLocation,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
    );
  }
}

class MapError extends MapState {
  final String error;

  MapError(this.error);
}
