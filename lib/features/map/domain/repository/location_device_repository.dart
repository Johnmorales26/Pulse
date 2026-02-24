import '../model/user_location.dart';

abstract class LocationDeviceRepository {
  Future<UserLocation> getCurrentLocation();
}