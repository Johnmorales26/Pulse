class UserProfile {
  final String username;
  final String email;
  final String? photoUrl;

  const UserProfile({
    required this.username,
    required this.email,
    this.photoUrl,
  });
}