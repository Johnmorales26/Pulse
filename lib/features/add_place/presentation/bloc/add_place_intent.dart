import 'package:pulse/features/map/domain/model/place_icon.dart';

abstract class AddPlaceIntent {}

class SelectCategoryIntent extends AddPlaceIntent {
  final PlaceIcon category;
  SelectCategoryIntent(this.category);
}

/// Disparado por el botón "Guardar". Transporta los valores de los campos
/// de texto desde la UI; la validación ocurre en el BLoC, no aquí.
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
