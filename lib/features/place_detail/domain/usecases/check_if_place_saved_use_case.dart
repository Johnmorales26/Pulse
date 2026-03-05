import 'package:pulse/features/place_detail/domain/repositories/place_repository.dart';

class CheckIfPlaceSavedUseCase {
  final PlaceRepository _repository;

  CheckIfPlaceSavedUseCase(this._repository);

  Future<bool> call(String uid, String placeId) =>
      _repository.isPlaceSaved(uid, placeId);
}