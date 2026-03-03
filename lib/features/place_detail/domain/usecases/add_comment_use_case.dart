import 'package:pulse/features/place_detail/domain/repositories/place_repository.dart';

class AddCommentUseCase {
  final PlaceRepository repository;

  AddCommentUseCase(this.repository);

  Future<void> call(String placeId, String comment) {
    return repository.addComment(placeId, comment);
  }
}
