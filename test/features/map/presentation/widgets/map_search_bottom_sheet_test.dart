import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pulse/core/navigation/router_names.dart';
import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/map/domain/model/place_photos.dart';
import 'package:pulse/features/map/domain/model/place_rating.dart';
import 'package:pulse/features/map/domain/model/user_location.dart';
import 'package:pulse/features/map/presentation/map_bloc.dart';
import 'package:pulse/features/map/presentation/map_intent.dart';
import 'package:pulse/features/map/presentation/map_state.dart';
import 'package:pulse/features/map/presentation/widgets/map_search_bottom_sheet.dart';
import 'package:pulse/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockMapBloc extends Mock implements MapBloc {}

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
// Helpers
// ---------------------------------------------------------------------------

/// Wraps the search sheet in a [Scaffold] + [BlocProvider] so that
/// [DarkTextField] (which needs a [Material] ancestor) and [BlocBuilder]
/// (which needs a provider) both have what they need.
Widget _searchSheetBody(MapBloc bloc) {
  return Scaffold(
    body: BlocProvider.value(
      value: bloc,
      child: const MapSearchBottomSheet(),
    ),
  );
}

/// Builds a [MaterialApp.router] with the given [router] config.
Widget _appWithRouter(GoRouter router) {
  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockMapBloc mockBloc;

  setUp(() {
    mockBloc = MockMapBloc();
    registerFallbackValue(SearchPlacesIntent(''));
    registerFallbackValue(ClearSearchIntent());
  });

  group('MapSearchBottomSheet', () {
    testWidgets('renders search field and results list', (tester) async {
      final testState = MapSuccess(
        locations: [
          _place(id: '1', name: 'Cafe Luna', latitude: 0, longitude: 0),
          _place(id: '2', name: 'Bar Sol', latitude: 0, longitude: 0),
        ],
        searchQuery: 'cafe',
        userLocation: _userLoc(0, 0),
      );

      when(() => mockBloc.state).thenReturn(testState);
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(testState));
      when(() => mockBloc.add(any())).thenReturn(null);

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => _searchSheetBody(mockBloc),
          ),
        ],
      );

      await tester.pumpWidget(_appWithRouter(router));
      await tester.pumpAndSettle();

      // Search field is present
      expect(find.byType(TextField), findsOneWidget);

      // Results show only matching places
      expect(find.text('Cafe Luna'), findsOneWidget);
      expect(find.text('Bar Sol'), findsNothing);
    });

    testWidgets('shows no results message when query has no matches',
        (tester) async {
      final testState = MapSuccess(
        locations: [
          _place(id: '1', name: 'Cafe Luna', latitude: 0, longitude: 0),
          _place(id: '2', name: 'Bar Sol', latitude: 0, longitude: 0),
        ],
        searchQuery: 'zzz',
      );

      when(() => mockBloc.state).thenReturn(testState);
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(testState));
      when(() => mockBloc.add(any())).thenReturn(null);

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => _searchSheetBody(mockBloc),
          ),
        ],
      );

      await tester.pumpWidget(_appWithRouter(router));
      await tester.pumpAndSettle();

      // "No places match your search" should be visible
      expect(find.text('No places match your search'), findsOneWidget);
    });

    testWidgets('renders empty (shrinks) when no results and no query',
        (tester) async {
      final testState = MapSuccess(
        locations: [],
        searchQuery: '',
      );

      when(() => mockBloc.state).thenReturn(testState);
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(testState));
      when(() => mockBloc.add(any())).thenReturn(null);

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => _searchSheetBody(mockBloc),
          ),
        ],
      );

      await tester.pumpWidget(_appWithRouter(router));
      await tester.pumpAndSettle();

      // No list items, no "no results" message
      expect(find.byType(ListTile), findsNothing);
      expect(find.text('No places match your search'), findsNothing);
    });

    testWidgets('tap item navigates to place detail', (tester) async {
      final testState = MapSuccess(
        locations: [
          _place(id: '1', name: 'Cafe Luna', latitude: 0, longitude: 0),
        ],
        searchQuery: 'cafe',
        userLocation: _userLoc(0, 0),
      );

      when(() => mockBloc.state).thenReturn(testState);
      when(() => mockBloc.stream).thenAnswer((_) => Stream.value(testState));
      when(() => mockBloc.add(any())).thenReturn(null);

      // Home route with a button that pushes the search sheet as a full-screen
      // route. This lets Navigator.pop() return to home after tapping a result.
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => _searchSheetBody(mockBloc),
                        ),
                      );
                    },
                    child: const Text('Open Search'),
                  ),
                ),
              );
            },
          ),
          GoRoute(
            path: '/place/:id',
            name: RouterNames.placeDetail,
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('Place Detail Screen'))),
          ),
        ],
      );

      await tester.pumpWidget(_appWithRouter(router));
      await tester.pumpAndSettle();

      // Open the search sheet
      await tester.tap(find.text('Open Search'));
      await tester.pumpAndSettle();

      // Verify results are rendered
      expect(find.text('Cafe Luna'), findsOneWidget);

      // Tap the result item
      await tester.tap(find.text('Cafe Luna'));
      await tester.pumpAndSettle();

      // After pop + pushNamed, we should be on the place detail screen
      expect(find.text('Place Detail Screen'), findsOneWidget);
    });
  });
}
