import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pulse/core/di/injection.dart';

class MapScreen extends StatelessWidget {
  final Logger _logger = sl<Logger>();
  MapboxMap? _mapboxMap;

  final CameraOptions _initialCameraOptions = CameraOptions(
    center: Point(coordinates: Position(-99.133209, 19.432608)),
    zoom: 13.0,
  );

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
    return Scaffold(
      body: MapWidget(
        key: const ValueKey('Pulse Map'),
        onMapCreated: _onMapCreated,
        cameraOptions: _initialCameraOptions,
        styleUri: MapboxStyles.DARK,
      ),
    );
  }
}
