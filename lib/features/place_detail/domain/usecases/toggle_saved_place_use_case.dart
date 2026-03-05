import 'package:pulse/features/place_detail/domain/repositories/place_repository.dart';

class ToggleSavedPlaceUseCase {
  final PlaceRepository _repository;

  ToggleSavedPlaceUseCase(this._repository);

  Future<void> call(
    String uid,
    String placeId, {
    required bool isCurrentlySaved,
  }) => _repository.toggleSavedPlace(uid, placeId, isCurrentlySaved: isCurrentlySaved);
}