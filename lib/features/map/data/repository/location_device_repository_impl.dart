import 'package:pulse/features/map/data/datasource/location_data_source.dart';
import 'package:pulse/features/map/domain/model/user_location.dart';

import '../../domain/repository/location_device_repository.dart';

class LocationDeviceRepositoryImpl implements LocationDeviceRepository {
  final LocationDataSource locationDataSource;

  LocationDeviceRepositoryImpl(this.locationDataSource);

  @override
  Future<UserLocation> getCurrentLocation() {
    return locationDataSource.getUserLocation();
  }


}
