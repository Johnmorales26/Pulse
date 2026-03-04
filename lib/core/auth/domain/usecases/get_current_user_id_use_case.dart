import '../repository/auth_repository.dart';

class GetCurrentUserIdUseCase {
  final AuthRepository _repository;

  GetCurrentUserIdUseCase(this._repository);

  /// Returns the current user's UID, or null if no session is active.
  String? call() => _repository.getCurrentUserId();
}
