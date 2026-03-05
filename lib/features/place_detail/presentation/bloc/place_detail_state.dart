import 'package:pulse/features/map/domain/model/place_comments.dart';
import 'package:pulse/features/map/domain/model/place_location.dart';

enum PlaceDetailStatus { initial, loading, success, error, unauthenticated }

class PlaceDetailState {
  final PlaceDetailStatus status;
  final String? errorMessage;
  final List<PlaceComments> comments;
  final PlaceLocation? place;
  final bool isSaved;

  PlaceDetailState({
    this.status = PlaceDetailStatus.initial,
    this.errorMessage,
    this.comments = const [],
    this.place,
    this.isSaved = false,
  });

  PlaceDetailState copyWith({
    PlaceDetailStatus? status,
    String? errorMessage,
    List<PlaceComments>? comments,
    PlaceLocation? place,
    bool? isSaved,
  }) {
    return PlaceDetailState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      comments: comments ?? this.comments,
      place: place ?? this.place,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}