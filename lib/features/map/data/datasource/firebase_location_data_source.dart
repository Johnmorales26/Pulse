import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/model/place_location.dart';
import '../../domain/model/place_photos.dart';
import '../../domain/model/place_rating.dart';

class FirebaseLocationDataSource {
  final FirebaseFirestore firestore;

  FirebaseLocationDataSource(this.firestore);

  Future<List<PlaceLocation>> fetchLocations() async {
    final snapshot = await firestore.collection('places').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      final locationMap = data['location'] as Map<String, dynamic>? ?? {};
      final photosMap = data['photos'] as Map<String, dynamic>? ?? {};
      final ratingMap = data['rating'] as Map<String, dynamic>? ?? {};

      return PlaceLocation(
        id: doc.id,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        createdBy: data['createdBy'] ?? '',
        description: data['description'] ?? '',
        latitude: (locationMap['latitude'] ?? 0.0).toDouble(),
        longitude: (locationMap['longitude'] ?? 0.0).toDouble(),
        name: data['name'] ?? '',
        photos: PlacePhotos(
          inside: List<String>.from(photosMap['inside'] ?? []),
          outside: List<String>.from(photosMap['outside'] ?? []),
        ),
        rating: PlaceRating(
          stars: (ratingMap['stars'] ?? 0).toDouble(),
          totalReviews: ratingMap['totalReviews'] ?? 0,
        ),
        type: data['type'] ?? '',
      );
    }).toList();
  }
}