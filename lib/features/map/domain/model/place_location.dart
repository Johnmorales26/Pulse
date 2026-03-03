import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/map/domain/model/place_photos.dart';
import 'package:pulse/features/map/domain/model/place_rating.dart';

class PlaceLocation {
  final String id;
  final DateTime createdAt;
  final String createdBy;
  final String description;
  final double latitude;
  final double longitude;
  final String name;
  final PlacePhotos photos;
  final PlaceRating rating;
  final String type;
  final List<PlaceComments> comments;

  PlaceLocation({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.photos,
    required this.rating,
    required this.type,
    required this.comments,
  });
}
