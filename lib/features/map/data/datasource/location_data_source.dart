import 'package:geolocator/geolocator.dart';
import '../../domain/model/user_location.dart';

class LocationDataSource {

  Future<UserLocation> getUserLocation() async {
    await _ensurePermissions();

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    return UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<void> _ensurePermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Los servicios de ubicación están desactivados.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Permiso de ubicación denegado.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
        'Permiso denegado permanentemente. Habilítalo desde Ajustes.',
      );
    }
  }
}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}