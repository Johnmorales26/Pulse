abstract class AuthRepository {
  /// Returns the UID of the currently authenticated user,
  /// or null if no session is active.
  String? getCurrentUserId();
}
