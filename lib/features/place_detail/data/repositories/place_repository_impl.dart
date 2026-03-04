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
