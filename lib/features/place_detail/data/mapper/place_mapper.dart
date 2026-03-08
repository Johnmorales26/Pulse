import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse/features/map/data/constants.dart';
import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/map/domain/model/place_photos.dart';
import 'package:pulse/features/map/domain/model/place_rating.dart';

class PlaceMapper {
  static PlaceLocation fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final locationMap =
        data[Constants.DATA_LOCATION] as Map<String, dynamic>? ?? {};
    final photosMap =
        data[Constants.DATA_PHOTOS] as Map<String, dynamic>? ?? {};
    final ratingMap =
        data[Constants.DATA_RATING] as Map<String, dynamic>? ?? {};

    return PlaceLocation(
      id: doc.id,
      createdAt:
          (data[Constants.DATA_CREATED_AT] as Timestamp?)?.toDate() ??
          DateTime.now(),
      createdBy: data[Constants.DATA_CREATED_BY] ?? '',
      description: data[Constants.DATA_DESCRIPTION] ?? '',
      latitude: (locationMap[Constants.DATA_LATITUDE] ?? 0.0).toDouble(),
      longitude: (locationMap[Constants.DATA_LONGITUDE] ?? 0.0).toDouble(),
      name: data[Constants.DATA_NAME] ?? '',
      photos: PlacePhotos(
        inside: List<String>.from(photosMap[Constants.DATA_INSIDE] ?? []),
        outside: List<String>.from(photosMap[Constants.DATA_OUTSIDE] ?? []),
      ),
      rating: PlaceRating(
        stars: (ratingMap[Constants.DATA_STARS] ?? 0).toDouble(),
        totalReviews: ratingMap[Constants.DATA_TOTAL_REVIEWS] ?? 0,
      ),
      type: (data[Constants.DATA_TYPE] ?? '').toString().trim(),
      comments: (data[Constants.DATA_COMMENTS] as List? ?? [])
          .map((e) {
            final commentMap = e as Map<String, dynamic>;
            return PlaceComments(
              createdAt:
                  (commentMap[Constants.DATA_CREATED_AT] as Timestamp?)
                      ?.toDate() ??
                  DateTime.now(),
              createdBy: commentMap[Constants.DATA_CREATED_BY] as String? ?? '',
              comment: commentMap[Constants.DATA_COMMENT] as String? ?? '',
            );
          })
          .toList()
          .reversed
          .toList(),
    );
  }
}
