import '../domain/model/place_location.dart';

abstract class MapState {}
class MapInitial extends MapState {}
class MapLoading extends MapState {}
class MapSuccess extends MapState {
  final List<PlaceLocation> locations;
  MapSuccess(this.locations);
}
class MapError extends MapState {
  final String error;
  MapError(this.error);
}