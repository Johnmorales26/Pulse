import 'package:go_router/go_router.dart';
import 'package:pulse/core/navigation/router_names.dart';
import 'package:pulse/core/navigation/transition.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/map/presentation/map_screen.dart';
import 'package:pulse/features/place_detail/presentation/place_detail_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouterNames.map,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RouterNames.map,
        name: 'map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/place/:id',
        name: 'placeDetail',
        pageBuilder: (context, state) {
          final location = state.extra as PlaceLocation;

          return buildElegantTransitionPage(
            state: state,
            child: PlaceDetailScreen(location: location),
          );
        },
      ),
    ],
  );
}
