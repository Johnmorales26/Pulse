import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lordicon/lordicon.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/features/map/presentation/map_bloc.dart';
import 'package:pulse/features/map/presentation/map_intent.dart';
import 'package:pulse/features/map/presentation/map_state.dart';

import '../domain/model/place_location.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => sl<MapBloc>()..add(FetchMapLocationsIntent()),
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            if (state is MapInitial || state is MapLoading) {
              return const MapWidgetLoading();
            } else if (state is MapError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is MapSuccess) {
              final locations = state.locations;

              return MapWidgetSuccess(locations: locations);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class MapWidgetLoading extends StatelessWidget {
  const MapWidgetLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = IconController.assets(
      'assets/animations/animation_pin.json',
    );

    controller.addStatusListener((status) {
      if (status == ControllerStatus.ready) {
        controller.playFromBeginning();
      }

      if (status == ControllerStatus.completed) {
        controller.playFromBeginning();
      }
    });

    return SizedBox(
      width: double.infinity,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconViewer(controller: controller, width: 128, height: 128),
            Text('Setting Up Map', style: Theme.of(context).textTheme.headlineMedium)
          ]
      )
    );
  }
}

class MapWidgetSuccess extends StatelessWidget {
  final List<PlaceLocation> locations;
  MapboxMap? _mapboxMap;

  final CameraOptions _initialCameraOptions = CameraOptions(
    center: Point(coordinates: Position(-99.133209, 19.432608)),
    zoom: 13.0,
  );

  MapWidgetSuccess({super.key, required this.locations});

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    await mapboxMap.compass.updateSettings(CompassSettings(enabled: false));

    await mapboxMap.scaleBar.updateSettings(ScaleBarSettings(enabled: false));

    await mapboxMap.logo.updateSettings(
      LogoSettings(
        position: OrnamentPosition.TOP_LEFT,
        marginLeft: 16,
        marginTop: 16,
      ),
    );

    await mapboxMap.attribution.updateSettings(
      AttributionSettings(
        position: OrnamentPosition.BOTTOM_RIGHT,
        marginRight: 16,
        marginBottom: 16,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey('Pulse Map'),
      onMapCreated: _onMapCreated,
      cameraOptions: _initialCameraOptions,
      styleUri: MapboxStyles.DARK,
    );
  }
}
