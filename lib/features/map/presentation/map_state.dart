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
  final Set<String> selectedCategories;

  MapSuccess({
    required this.locations,
    this.selectedLocation,
    this.userLocation,
    this.lastLocationUpdate,
    this.selectedCategories = const {},
  });

  /// Returns filtered locations based on selectedCategories.
  /// If empty, returns all locations.
  List<PlaceLocation> get filteredLocations {
    if (selectedCategories.isEmpty) {
      return locations;
    }
    return locations
        .where((location) => selectedCategories.contains(location.type))
        .toList();
  }

  /// Returns unique categories from all locations.
  Set<String> get availableCategories {
    return locations.map((l) => l.type).toSet();
  }

  MapSuccess copyWith({
    List<PlaceLocation>? locations,
    PlaceLocation? selectedLocation,
    UserLocation? userLocation,
    bool clearSelection = false,
    DateTime? lastLocationUpdate,
    Set<String>? selectedCategories,
  }) {
    return MapSuccess(
      locations: locations ?? this.locations,
      selectedLocation: clearSelection
          ? null
          : (selectedLocation ?? this.selectedLocation),
      userLocation: userLocation ?? this.userLocation,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      selectedCategories: selectedCategories ?? this.selectedCategories,
    );
  }
}

class MapError extends MapState {
  final String error;

  MapError(this.error);
}
