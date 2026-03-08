import 'package:pulse/features/map/domain/model/place_icon.dart';

enum AddPlaceStatus { idle, loading, validationError, success, failure, unauthenticated }

class AddPlaceState {
  final PlaceIcon? selectedCategory;
  final AddPlaceStatus status;
  final String? errorMessage;

  const AddPlaceState({
    this.selectedCategory,
    this.status = AddPlaceStatus.idle,
    this.errorMessage,
  });

  AddPlaceState copyWith({
    PlaceIcon? selectedCategory,
    AddPlaceStatus? status,
    String? errorMessage,
  }) {
    return AddPlaceState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
