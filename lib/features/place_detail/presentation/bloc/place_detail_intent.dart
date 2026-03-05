import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';

abstract class PlaceDetailIntent {}

class InitializePlaceDetailIntent extends PlaceDetailIntent {
  final List<PlaceComments> initialComments;
  InitializePlaceDetailIntent(this.initialComments);
}

class AddCommentIntent extends PlaceDetailIntent {
  final String placeId;
  final String comment;
  AddCommentIntent(this.placeId, this.comment);
}

class ObservePlaceDetailIntent extends PlaceDetailIntent {
  final String placeId;
  ObservePlaceDetailIntent(this.placeId);
}

class UpdatePlaceDetailIntent extends PlaceDetailIntent {
  final PlaceLocation place;

  UpdatePlaceDetailIntent(this.place);
}

class SetErrorIntent extends PlaceDetailIntent {
  final String message;

  SetErrorIntent(this.message);
}

class ToggleSavePlaceIntent extends PlaceDetailIntent {
  final String placeId;

  ToggleSavePlaceIntent(this.placeId);
}