import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/core/navigation/router_names.dart';
import 'package:pulse/features/map/presentation/map_bloc.dart';
import 'package:pulse/features/map/presentation/map_intent.dart';
import 'package:pulse/features/map/presentation/map_state.dart';
import 'package:pulse/features/map/presentation/widgets/location_card.dart';
import 'package:pulse/features/map/presentation/widgets/map_widget_loading.dart';
import 'package:pulse/features/map/presentation/widgets/map_widget_success.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<MapBloc>()..add(FetchMapLocationsIntent()),
        child: Builder(
          builder: (innerContext) {
            return Stack(
              children: [
                BlocBuilder<MapBloc, MapState>(
                  buildWhen: (previous, current) {
                    if (previous is MapSuccess && current is MapSuccess) {
                      return previous.locations != current.locations;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    if (state is MapInitial || state is MapLoading) {
                      return const MapWidgetLoading();
                    } else if (state is MapError) {
                      return Center(child: Text('Error: ${state.error}'));
                    } else if (state is MapSuccess) {
                      final locations = state.locations;
                      final userLocation = state.userLocation;

                      return MapWidgetSuccess(
                        userLocation: userLocation,
                        locations: locations,
                        onLocationSelected: (location) {
                          innerContext.read<MapBloc>().add(
                            SelectMapLocationIntent(location),
                          );
                        },
                        // Recibe las coordenadas ya limpias (solo doubles) y
                        // navega a la pantalla de creación de lugar.
                        onLongPress: (lat, lng) {
                          innerContext.pushNamed(
                            RouterNames.addPlace,
                            extra: (lat, lng),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),

                Align(
                  alignment: .centerEnd,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        innerContext.read<MapBloc>().add(
                          FetchUserLocationIntent(),
                        );
                      },
                      child: Icon(Icons.my_location_outlined),
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: .topEnd,
                      child: InkWell(
                        onTap: () {
                          context.pushNamed(RouterNames.auth);
                        },
                        child: Image.asset(
                          'assets/icons/locations/ic_profile.png',
                          width: 48.0,
                          height: 48.0,
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: .bottomCenter,
                  child: BlocBuilder<MapBloc, MapState>(
                    builder: (context, state) {
                      if (state is MapSuccess &&
                          state.selectedLocation != null) {
                        return LocationCard(
                          location: state.selectedLocation!,
                          onClose: () {
                            context.read<MapBloc>().add(
                              DeselectMapLocationIntent(),
                            );
                          },
                          onTap: (location) {
                            context.pushNamed(
                              RouterNames.placeDetail,
                              pathParameters: {'id': location.id},
                              extra: location,
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
