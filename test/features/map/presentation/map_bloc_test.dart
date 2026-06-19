import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/map/domain/model/place_photos.dart';
import 'package:pulse/features/map/domain/model/place_rating.dart';
import 'package:pulse/features/map/domain/model/user_location.dart';
import 'package:pulse/features/map/domain/usecases/get_map_location_use_case.dart';
import 'package:pulse/features/map/domain/usecases/get_user_location_use_case.dart';
import 'package:pulse/features/map/presentation/map_bloc.dart';
import 'package:pulse/features/map/presentation/map_intent.dart';
import 'package:pulse/features/map/presentation/map_state.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockGetMapLocationsUseCase extends Mock
    implements GetMapLocationsUseCase {}

class MockGetUserLocationUseCase extends Mock
    implements GetUserLocationUseCase {}

// ---------------------------------------------------------------------------
// Test fixtures
// ---------------------------------------------------------------------------

PlaceLocation _place({
  required String id,
  required String name,
  required double latitude,
  required double longitude,
  String type = 'restaurant',
}) {
  return PlaceLocation(
    id: id,
    createdAt: DateTime(2025),
    createdBy: 'user1',
    description: 'A place',
    latitude: latitude,
    longitude: longitude,
    name: name,
    photos: PlacePhotos(inside: [], outside: []),
    rating: PlaceRating(stars: 4.0, totalReviews: 10),
    type: type,
    comments: [],
  );
}

UserLocation _userLoc(double lat, double lng) =>
    UserLocation(latitude: lat, longitude: lng);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockGetMapLocationsUseCase mockGetMapLocationsUseCase;
  late MockGetUserLocationUseCase mockGetUserLocationUseCase;

  setUp(() {
    mockGetMapLocationsUseCase = MockGetMapLocationsUseCase();
    mockGetUserLocationUseCase = MockGetUserLocationUseCase();
  });

  group('MapBloc search intents', () {
    blocTest<MapBloc, MapState>(
      'SearchPlacesIntent sets searchQuery on MapSuccess',
      build: () => MapBloc(
        mockGetMapLocationsUseCase,
        mockGetUserLocationUseCase,
      ),
      seed: () => MapSuccess(locations: []),
      act: (bloc) => bloc.add(SearchPlacesIntent('cafe')),
      expect: () => [
        isA<MapSuccess>().having(
          (s) => s.searchQuery,
          'searchQuery',
          'cafe',
        ),
      ],
    );

    blocTest<MapBloc, MapState>(
      'ClearSearchIntent resets searchQuery to empty string',
      build: () => MapBloc(
        mockGetMapLocationsUseCase,
        mockGetUserLocationUseCase,
      ),
      seed: () => MapSuccess(
        locations: [],
        searchQuery: 'cafe',
      ),
      act: (bloc) => bloc.add(ClearSearchIntent()),
      expect: () => [
        isA<MapSuccess>().having(
          (s) => s.searchQuery,
          'searchQuery',
          '',
        ),
      ],
    );

    blocTest<MapBloc, MapState>(
      'SearchPlacesIntent no-ops on non-MapSuccess state',
      build: () => MapBloc(
        mockGetMapLocationsUseCase,
        mockGetUserLocationUseCase,
      ),
      seed: () => MapLoading(),
      act: (bloc) => bloc.add(SearchPlacesIntent('cafe')),
      expect: () => [],
    );

    blocTest<MapBloc, MapState>(
      'ClearSearchIntent no-ops on non-MapSuccess state',
      build: () => MapBloc(
        mockGetMapLocationsUseCase,
        mockGetUserLocationUseCase,
      ),
      seed: () => MapInitial(),
      act: (bloc) => bloc.add(ClearSearchIntent()),
      expect: () => [],
    );

    blocTest<MapBloc, MapState>(
      'searchQuery persists across unrelated state changes',
      build: () => MapBloc(
        mockGetMapLocationsUseCase,
        mockGetUserLocationUseCase,
      ),
      seed: () => MapSuccess(
        locations: [],
        searchQuery: 'pizza',
      ),
      act: (bloc) => bloc.add(SelectMapLocationIntent(_place(
        id: '1',
        name: 'Pizza Place',
        latitude: 0,
        longitude: 0,
      ))),
      expect: () => [
        isA<MapSuccess>()
            .having((s) => s.searchQuery, 'searchQuery', 'pizza')
            .having((s) => s.selectedLocation, 'selectedLocation', isNotNull),
      ],
    );
  });

  group('MapSuccess.searchedAndSortedLocations', () {
    test('returns all locations when searchQuery is empty', () {
      final state = MapSuccess(
        locations: [
          _place(id: '1', name: 'Cafe A', latitude: 0, longitude: 0),
          _place(id: '2', name: 'Cafe B', latitude: 0, longitude: 0),
          _place(id: '3', name: 'Bar C', latitude: 0, longitude: 0),
        ],
      );

      expect(state.searchedAndSortedLocations.length, 3);
    });

    test('filters by substring match (case-insensitive)', () {
      final state = MapSuccess(
        locations: [
          _place(id: '1', name: 'Cafe Luna', latitude: 0, longitude: 0),
          _place(id: '2', name: 'Bar Sol', latitude: 0, longitude: 0),
          _place(id: '3', name: 'CAFE MARTE', latitude: 0, longitude: 0),
          _place(id: '4', name: 'La Esquina', latitude: 0, longitude: 0),
        ],
        searchQuery: 'cafe',
      );

      final results = state.searchedAndSortedLocations;
      expect(results.length, 2);
      expect(results.map((p) => p.id), containsAll(['1', '3']));
    });

    test('returns empty list when no names match query', () {
      final state = MapSuccess(
        locations: [
          _place(id: '1', name: 'Cafe Luna', latitude: 0, longitude: 0),
          _place(id: '2', name: 'Bar Sol', latitude: 0, longitude: 0),
        ],
        searchQuery: 'zzz',
      );

      expect(state.searchedAndSortedLocations, isEmpty);
    });

    test('sorts by distance when userLocation is available', () {
      // User at (0, 0). Place A at (0, 0.01) ≈ ~1.1 km, Place B at (0, 0.001) ≈ ~111 m
      final state = MapSuccess(
        locations: [
          _place(
            id: 'far',
            name: 'Far Place',
            latitude: 0,
            longitude: 0.01,
          ),
          _place(
            id: 'near',
            name: 'Near Place',
            latitude: 0,
            longitude: 0.001,
          ),
        ],
        userLocation: _userLoc(0, 0),
      );

      final results = state.searchedAndSortedLocations;
      expect(results[0].id, 'near'); // closer first
      expect(results[1].id, 'far');
    });

    test('falls back to alphabetical sort when userLocation is null', () {
      final state = MapSuccess(
        locations: [
          _place(id: 'z', name: 'Zebra Cafe', latitude: 1, longitude: 1),
          _place(id: 'a', name: 'Alpha Bar', latitude: 2, longitude: 2),
          _place(id: 'm', name: 'Mango Place', latitude: 3, longitude: 3),
        ],
        userLocation: null,
      );

      final results = state.searchedAndSortedLocations;
      expect(results[0].name, 'Alpha Bar');
      expect(results[1].name, 'Mango Place');
      expect(results[2].name, 'Zebra Cafe');
    });

    test('combines search filter and distance sort', () {
      // User at (0, 0). All three contain "cafe".
      // Near Cafe: (0, 0.001) ≈ ~111 m
      // Mid Cafe:  (0, 0.01)  ≈ ~1.1 km
      // Far Cafe:  (0, 0.1)   ≈ ~11 km
      final state = MapSuccess(
        locations: [
          _place(
            id: 'far',
            name: 'Far Cafe',
            latitude: 0,
            longitude: 0.1,
          ),
          _place(
            id: 'near',
            name: 'Near Cafe',
            latitude: 0,
            longitude: 0.001,
          ),
          _place(
            id: 'mid',
            name: 'Mid Cafe',
            latitude: 0,
            longitude: 0.01,
          ),
          _place(id: 'other', name: 'Other Bar', latitude: 0, longitude: 0),
        ],
        userLocation: _userLoc(0, 0),
        searchQuery: 'cafe',
      );

      final results = state.searchedAndSortedLocations;
      expect(results.length, 3);
      expect(results[0].id, 'near');
      expect(results[1].id, 'mid');
      expect(results[2].id, 'far');
    });

    test('respects category filters from filteredLocations', () {
      final state = MapSuccess(
        locations: [
          _place(
            id: '1',
            name: 'Cafe One',
            latitude: 0,
            longitude: 0,
            type: 'restaurant',
          ),
          _place(
            id: '2',
            name: 'Cafe Two',
            latitude: 0,
            longitude: 0,
            type: 'bar',
          ),
        ],
        selectedCategories: {'restaurant'},
        searchQuery: 'cafe',
      );

      final results = state.searchedAndSortedLocations;
      expect(results.length, 1);
      expect(results.single.id, '1');
    });
  });
}
