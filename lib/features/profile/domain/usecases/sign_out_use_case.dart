import 'package:pulse/features/auth/domain/repository/user_auth_repository.dart';

class SignOutUseCase {
  final UserAuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() => _repository.signOut();
}