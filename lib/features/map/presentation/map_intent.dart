import '../domain/model/place_location.dart';

abstract class MapIntent {}

class FetchUserLocationIntent extends MapIntent {}

class FetchMapLocationsIntent extends MapIntent {}

class SelectMapLocationIntent extends MapIntent {
  final PlaceLocation location;
  SelectMapLocationIntent(this.location);
}

class DeselectMapLocationIntent extends MapIntent {}

class ToggleMapFilterIntent extends MapIntent {
  final String category;
  ToggleMapFilterIntent(this.category);
}

class ClearMapFiltersIntent extends MapIntent {}

class SearchPlacesIntent extends MapIntent {
  final String query;
  SearchPlacesIntent(this.query);
}

class ClearSearchIntent extends MapIntent {}