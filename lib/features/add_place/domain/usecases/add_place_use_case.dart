import '../model/new_place.dart';
import '../repository/add_place_repository.dart';

class AddPlaceUseCase {
  final AddPlaceRepository repository;

  AddPlaceUseCase(this.repository);

  Future<void> call(NewPlace place) => repository.addPlace(place);
}
