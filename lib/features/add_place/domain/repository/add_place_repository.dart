import '../model/new_place.dart';

abstract class AddPlaceRepository {
  Future<void> addPlace(NewPlace place);
}
