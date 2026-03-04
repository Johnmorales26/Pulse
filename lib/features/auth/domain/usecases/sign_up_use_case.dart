import '../repository/user_auth_repository.dart';

class SignUpUseCase {
  final UserAuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<void> call({
    required String username,
    required String email,
    required String password,
  }) => _repository.signUp(username: username, email: email, password: password);
}