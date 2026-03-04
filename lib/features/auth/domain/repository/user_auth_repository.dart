abstract class UserAuthRepository {
  Future<void> signIn({required String email, required String password});
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  });
  Future<void> signOut();
}