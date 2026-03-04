abstract class AuthIntent {}

class SignInIntent extends AuthIntent {
  final String email;
  final String password;

  SignInIntent({required this.email, required this.password});
}

class SignUpIntent extends AuthIntent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpIntent({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}