import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/features/map/domain/model/place_icon.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/map/domain/model/user_location.dart';
import 'package:pulse/features/map/presentation/map_bloc.dart';
import 'package:pulse/features/map/presentation/map_state.dart';
import 'package:toastification/toastification.dart';

class MapWidgetSuccess extends StatelessWidget
    implements OnPointAnnotationClickListener {
  final Logger logger = sl<Logger>();
  final UserLocation? userLocation;
  final List<PlaceLocation> locations;
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  PointAnnotation? _userAnnotation;
  final void Function(PlaceLocation) onLocationSelected;

  MapWidgetSuccess({
    super.key,
    required this.userLocation,
    required this.locations,
    required this.onLocationSelected,
  });

  final Map<String, PlaceLocation> _annotationMap = {};

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

    await _addMarkersToMap(mapboxMap);

    await _updateUserLocationPin(userLocation);
  }

  Future<void> _addMarkersToMap(MapboxMap mapboxMap) async {
    _pointAnnotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();
    _pointAnnotationManager?.addOnPointAnnotationClickListener(this);

    for (var loc in locations) {
      try {
        final place = PlaceIcon.fromId(loc.type);

        final ByteData bytes = await rootBundle.load(place.asset);
        final Uint8List imageBytes = bytes.buffer.asUint8List();

        final pointAnnotationOptions = PointAnnotationOptions(
          geometry: Point(coordinates: Position(loc.longitude, loc.latitude)),
          image: imageBytes,
          iconSize: 0.1,
        );

        final annotation = await _pointAnnotationManager!.create(
          pointAnnotationOptions,
        );
        _annotationMap[annotation.id] = loc;
      } catch (e) {
        logger.e('Log of Manager -> Error to add pin of ${loc.name}: $e');
      }
    }
  }

  Future<void> _updateUserLocationPin(UserLocation? loc) async {
    if (loc == null || _pointAnnotationManager == null) return;

    try {
      final ByteData bytes = await rootBundle.load('assets/icons/locations/ic_location_user.png');
      final Uint8List imageBytes = bytes.buffer.asUint8List();

      final point = Point(coordinates: Position(loc.longitude, loc.latitude));

      if (_userAnnotation == null) {
        final options = PointAnnotationOptions(geometry: point, image: imageBytes, iconSize: 0.1);
        _userAnnotation = await _pointAnnotationManager!.create(options);
      } else {
        _userAnnotation!.geometry = point;
        await _pointAnnotationManager!.update(_userAnnotation!);
      }
    } catch (e) {
      logger.e('Error to paint location from user');
    }
  }

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    final selectedLocation = _annotationMap[annotation.id];

    if (selectedLocation != null) {
      onLocationSelected(selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraOptions = CameraOptions(
      center: Point(
        coordinates: Position(
          userLocation?.longitude ?? -99.133209,
          userLocation?.latitude ?? 19.432608,
        ),
      ),
      zoom: 13.0,
    );

    return BlocListener<MapBloc, MapState>(
      listenWhen: (previous, current) {
        if (previous is MapSuccess && current is MapSuccess) {
          return previous.lastLocationUpdate != current.lastLocationUpdate &&
              current.userLocation != null;
        }
        return false;
      },
      listener: (context, state) {
        if (state is MapSuccess && state.userLocation != null) {
          _mapboxMap?.flyTo(
            CameraOptions(
              center: Point(
                coordinates: Position(
                  state.userLocation!.longitude,
                  state.userLocation!.latitude,
                ),
              ),
              zoom: 15.0,
            ),
            MapAnimationOptions(duration: 1500),
          );
          _updateUserLocationPin(state.userLocation);
        }
      },
      child: MapWidget(
        textureView: true,
        key: const ValueKey('Pulse Map'),
        onMapCreated: _onMapCreated,
        cameraOptions: cameraOptions,
        styleUri: MapboxStyles.DARK,
      ),
    );
  }
}