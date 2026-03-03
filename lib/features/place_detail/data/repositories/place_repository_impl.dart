import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/place_detail/data/mapper/place_mapper.dart';
import '../../domain/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final FirebaseFirestore _firestore;
  final Logger logger;

  PlaceRepositoryImpl(this._firestore, this.logger);

  @override
  Stream<PlaceLocation> getPlaceStream(String placeId) {
    return _firestore
        .collection('places')
        .doc(placeId)
        .snapshots()
        .map((snapshot) => PlaceMapper.fromFirestore(snapshot));
  }

  @override
  Future<void> addComment(String placeId, String comment) async {
    try {
      // Usamos .update() con FieldValue.arrayUnion para añadir al array sin sobrescribir el documento
      await _firestore.collection('places').doc(placeId).update({
        'comments': FieldValue.arrayUnion([
          {
            'comment': comment,
            'createdBy': 'user_1',
            'createdAt': Timestamp.now(), // ✅ usar Timestamp.now()
          },
        ]),
      });
    } catch (e) {
      logger.e(e);
      throw Exception('Error al agregar el comentario:$e');
    }
  }
}
