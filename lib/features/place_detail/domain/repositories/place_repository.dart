import 'package:pulse/features/map/domain/model/place_location.dart';

abstract class PlaceRepository {
  Stream<PlaceLocation> getPlaceStream(String placeId);
  Future<void> addComment(String placeId, String comment);
  Future<bool> isPlaceSaved(String uid, String placeId);
  Future<void> toggleSavedPlace(
    String uid,
    String placeId, {
    required bool isCurrentlySaved,
  });
  Future<List<PlaceLocation>> getSavedPlaces(String uid);
}