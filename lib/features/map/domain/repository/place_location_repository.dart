import '../model/place_location.dart';

abstract class PlaceLocationRepository {
  Future<List<PlaceLocation>> getLocations();
}