import 'package:pulse/features/map/domain/model/place_location.dart';

abstract class PlaceRepository {
  Stream<PlaceLocation> getPlaceStream(String placeId);
  Future<void> addComment(String placeId, String comment);
}
