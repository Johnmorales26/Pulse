import 'package:pulse/features/map/domain/model/place_location.dart';
import 'package:pulse/features/place_detail/domain/repositories/place_repository.dart';

class GetPlaceStreamUseCase {
  final PlaceRepository repository;
  GetPlaceStreamUseCase(this.repository);

  Stream<PlaceLocation> call(String placeId) =>
      repository.getPlaceStream(placeId);
}
