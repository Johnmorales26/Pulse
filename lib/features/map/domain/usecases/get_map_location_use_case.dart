import '../model/place_location.dart';
import '../repository/place_location_repository.dart';

class GetMapLocationsUseCase {
  final PlaceLocationRepository repository;

  GetMapLocationsUseCase(this.repository);

  Future<List<PlaceLocation>> call() async {
    return await repository.getLocations();
  }
}