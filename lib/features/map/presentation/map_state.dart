import 'package:pulse/core/utils/distance.dart';
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
  final String searchQuery;

  MapSuccess({
    required this.locations,
    this.selectedLocation,
    this.userLocation,
    this.lastLocationUpdate,
    this.selectedCategories = const {},
    this.searchQuery = '',
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

  /// Returns locations filtered by search query (case-insensitive substring
  /// match on name), sorted by distance from the user. Falls back to
  /// alphabetical sort when user location is unavailable.
  List<PlaceLocation> get searchedAndSortedLocations {
    final base = searchQuery.isEmpty
        ? filteredLocations
        : filteredLocations
            .where((p) =>
                p.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

    if (userLocation != null) {
      base.sort((a, b) {
        final dA = haversineDistance(
          userLocation!.latitude,
          userLocation!.longitude,
          a.latitude,
          a.longitude,
        );
        final dB = haversineDistance(
          userLocation!.latitude,
          userLocation!.longitude,
          b.latitude,
          b.longitude,
        );
        return dA.compareTo(dB);
      });
    } else {
      base.sort((a, b) => a.name.compareTo(b.name));
    }
    return base;
  }

  MapSuccess copyWith({
    List<PlaceLocation>? locations,
    PlaceLocation? selectedLocation,
    UserLocation? userLocation,
    bool clearSelection = false,
    DateTime? lastLocationUpdate,
    Set<String>? selectedCategories,
    String? searchQuery,
  }) {
    return MapSuccess(
      locations: locations ?? this.locations,
      selectedLocation: clearSelection
          ? null
          : (selectedLocation ?? this.selectedLocation),
      userLocation: userLocation ?? this.userLocation,
      lastLocationUpdate: lastLocationUpdate ?? this.lastLocationUpdate,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class MapError extends MapState {
  final String error;

  MapError(this.error);
}
