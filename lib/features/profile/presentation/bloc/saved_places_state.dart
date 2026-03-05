import 'package:pulse/features/map/domain/model/place_location.dart';

abstract class SavedPlacesState {}

class SavedPlacesInitial extends SavedPlacesState {}

class SavedPlacesLoading extends SavedPlacesState {}

class SavedPlacesLoaded extends SavedPlacesState {
  final List<PlaceLocation> places;

  SavedPlacesLoaded(this.places);
}

class SavedPlacesError extends SavedPlacesState {
  final String message;

  SavedPlacesError(this.message);
}