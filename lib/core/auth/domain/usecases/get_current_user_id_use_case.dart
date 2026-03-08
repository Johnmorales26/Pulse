import '../repository/auth_repository.dart';

class GetCurrentUserIdUseCase {
  final AuthRepository _repository;

  GetCurrentUserIdUseCase(this._repository);

  String? call() => _repository.getCurrentUserId();
}
