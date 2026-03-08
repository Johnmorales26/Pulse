import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse/core/auth/domain/exceptions/unauthenticated_exception.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/add_place/domain/model/new_place.dart';
import 'package:pulse/features/map/data/constants.dart';

class AddPlaceDatasource {
  final FirebaseFirestore firestore;
  final GetCurrentUserIdUseCase _getCurrentUserId;

  AddPlaceDatasource(this.firestore, this._getCurrentUserId);

  Future<void> addPlace(NewPlace place) async {
    final uid = _getCurrentUserId();
    if (uid == null) throw const UnauthenticatedException();

    final payload = {
      Constants.DATA_NAME: place.name,
      Constants.DATA_DESCRIPTION: place.description,
      Constants.DATA_TYPE: place.type,
      Constants.DATA_LOCATION: {
        Constants.DATA_LATITUDE: place.latitude,
        Constants.DATA_LONGITUDE: place.longitude,
      },
      Constants.DATA_CREATED_AT: FieldValue.serverTimestamp(),
      Constants.DATA_CREATED_BY: uid,
      Constants.DATA_COMMENTS: [],
      Constants.DATA_PHOTOS: {
        Constants.DATA_INSIDE: [],
        Constants.DATA_OUTSIDE: [],
      },
      Constants.DATA_RATING: {
        Constants.DATA_STARS: 0,
        Constants.DATA_TOTAL_REVIEWS: 0,
      },
    };

    await firestore.collection(Constants.COLL_PLACES).add(payload);
  }
}
