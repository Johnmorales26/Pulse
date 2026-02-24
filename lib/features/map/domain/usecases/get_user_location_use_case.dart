import '../model/user_location.dart';
import '../repository/location_device_repository.dart';

class GetUserLocationUseCase {
  final LocationDeviceRepository repository;
  GetUserLocationUseCase(this.repository);

  Future<UserLocation> call() async {
    return await repository.getCurrentLocation();
  }
}