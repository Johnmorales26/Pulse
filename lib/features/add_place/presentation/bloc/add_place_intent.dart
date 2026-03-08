import 'package:pulse/features/map/domain/model/place_icon.dart';

abstract class AddPlaceIntent {}

class SelectCategoryIntent extends AddPlaceIntent {
  final PlaceIcon category;
  SelectCategoryIntent(this.category);
}

class SubmitPlaceIntent extends AddPlaceIntent {
  final String name;
  final String description;
  final double lat;
  final double lng;

  SubmitPlaceIntent({
    required this.name,
    required this.description,
    required this.lat,
    required this.lng,
  });
}
