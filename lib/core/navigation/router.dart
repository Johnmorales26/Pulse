import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/core/navigation/router_names.dart';
import 'package:pulse/core/navigation/transition.dart';
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
    ],
  );
}
