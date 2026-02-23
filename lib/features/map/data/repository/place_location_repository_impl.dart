import '../../domain/model/place_location.dart';
import '../../domain/repository/place_location_repository.dart';
import '../datasource/firebase_location_data_source.dart';

class PlaceLocationRepositoryImpl implements PlaceLocationRepository {
  final FirebaseLocationDataSource dataSource;

  PlaceLocationRepositoryImpl(this.dataSource);

  @override
  Future<List<PlaceLocation>> getLocations() async {
    return await dataSource.fetchLocations();
  }
}