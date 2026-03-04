import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/core/navigation/router_names.dart';
import 'package:pulse/core/navigation/transition.dart';
import 'package:pulse/features/add_place/add_place_injection.dart'
    as add_place_di;
import 'package:pulse/features/add_place/presentation/add_place_screen.dart';
import 'package:pulse/features/add_place/presentation/bloc/add_place_bloc.dart';
import 'package:pulse/features/auth/presentation/login_screen.dart';
import 'package:pulse/features/map/presentation/map_screen.dart';
import 'package:pulse/features/place_detail/presentation/bloc/place_detail_bloc.dart';
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
        path: '/add-place',
        name: RouterNames.addPlace,
        pageBuilder: (context, state) {
          // Las coordenadas llegan como un record Dart (lat, lng) en extra,
          // evitando el uso de Map<String, dynamic> y manteniendo tipado fuerte.
          final (double lat, double lng) = state.extra! as (double, double);
          return buildElegantTransitionPage(
            state: state,
            child: BlocProvider(
              create: (_) => add_place_di.sl<AddPlaceBloc>(),
              child: AddPlaceScreen(lat: lat, lng: lng),
            ),
          );
        },
      ),
      GoRoute(
        path: '/place/:id',
        name: RouterNames.placeDetail,
        pageBuilder: (context, state) {
          final placeId = state.pathParameters['id']!;

          return buildElegantTransitionPage(
            state: state,
            child: BlocProvider(
              create: (context) => sl<PlaceDetailBloc>(),
              child: PlaceDetailScreen(placeId: placeId),
            ),
          );
        },
      ),
      GoRoute(
        path: '/auth',
        name: RouterNames.auth,
        pageBuilder: (context, state) {
          return buildElegantTransitionPage(state: state, child: LoginScreen());
        },
      ),
    ],
  );
}
