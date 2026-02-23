import '../domain/model/place_location.dart';

abstract class MapIntent {}
class FetchMapLocationsIntent extends MapIntent {}
class SelectMapLocationIntent extends MapIntent {
  final PlaceLocation location;
  SelectMapLocationIntent(this.location);
}

class DeselectMapLocationIntent extends MapIntent {}