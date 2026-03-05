import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/place_detail/domain/repositories/place_repository.dart';

class GetSavedPlacesUseCase {
  final PlaceRepository _repository;

  GetSavedPlacesUseCase(this._repository);

  Future<List<PlaceLocation>> call(String uid) => _repository.getSavedPlaces(uid);
}