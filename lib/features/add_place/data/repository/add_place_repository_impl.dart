import 'package:pulse/features/add_place/data/datasource/add_place_datasource.dart';
import 'package:pulse/features/add_place/domain/model/new_place.dart';
import 'package:pulse/features/add_place/domain/repository/add_place_repository.dart';

class AddPlaceRepositoryImpl implements AddPlaceRepository {
  final AddPlaceDatasource dataSource;

  AddPlaceRepositoryImpl(this.dataSource);

  @override
  Future<void> addPlace(NewPlace place) => dataSource.addPlace(place);
}
