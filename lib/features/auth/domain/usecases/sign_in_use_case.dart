import '../repository/user_auth_repository.dart';

class SignInUseCase {
  final UserAuthRepository _repository;

  SignInUseCase(this._repository);

  Future<void> call({required String email, required String password}) =>
      _repository.signIn(email: email, password: password);
}