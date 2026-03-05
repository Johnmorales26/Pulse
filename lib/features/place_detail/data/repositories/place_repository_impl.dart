import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:pulse/core/auth/domain/exceptions/unauthenticated_exception.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/place_detail/data/mapper/place_mapper.dart';
import '../../domain/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final FirebaseFirestore _firestore;
  final Logger logger;
  final GetCurrentUserIdUseCase _getCurrentUserId;

  PlaceRepositoryImpl(this._firestore, this.logger, this._getCurrentUserId);

  @override
  Stream<PlaceLocation> getPlaceStream(String placeId) {
    return _firestore
        .collection('places')
        .doc(placeId)
        .snapshots()
        .map((snapshot) => PlaceMapper.fromFirestore(snapshot));
  }

  @override
  Future<bool> isPlaceSaved(String uid, String placeId) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final saved = List<String>.from(doc.data()?['savedPlaces'] ?? []);
    return saved.contains(placeId);
  }

  @override
  Future<void> toggleSavedPlace(
    String uid,
    String placeId, {
    required bool isCurrentlySaved,
  }) async {
    final userRef = _firestore.collection('users').doc(uid);
    // arrayUnion/arrayRemove operan atómicamente en Firestore — nunca se
    // descarga el arreglo completo a memoria, previniendo condiciones de carrera.
    if (isCurrentlySaved) {
      await userRef.update({
        'savedPlaces': FieldValue.arrayRemove([placeId]),
      });
    } else {
      await userRef.update({
        'savedPlaces': FieldValue.arrayUnion([placeId]),
      });
    }
  }

  @override
  Future<List<PlaceLocation>> getSavedPlaces(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    final savedIds = List<String>.from(userDoc.data()?['savedPlaces'] ?? []);

    if (savedIds.isEmpty) return [];

    // Firestore whereIn limit is 30 items per query — chunk to handle larger lists.
    final places = <PlaceLocation>[];
    for (var i = 0; i < savedIds.length; i += 30) {
      final chunk = savedIds.sublist(i, (i + 30).clamp(0, savedIds.length));
      final snapshot = await _firestore
          .collection('places')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      places.addAll(snapshot.docs.map(PlaceMapper.fromFirestore));
    }

    return places;
  }

  @override
  Future<void> addComment(String placeId, String comment) async {
    // Defensa en profundidad: aunque el BLoC ya validó, el repositorio
    // vuelve a comprobar antes de escribir en Firestore.
    final uid = _getCurrentUserId();
    if (uid == null) throw const UnauthenticatedException();

    try {
      await _firestore.collection('places').doc(placeId).update({
        'comments': FieldValue.arrayUnion([
          {
            'comment': comment,
            'createdBy': uid,
            'createdAt': Timestamp.now(),
          },
        ]),
      });
    } catch (e) {
      logger.e(e);
      throw Exception('Error al agregar el comentario: $e');
    }
  }
}
