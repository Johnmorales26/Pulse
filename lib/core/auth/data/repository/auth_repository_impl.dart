import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;

  AuthRepositoryImpl(this._auth);

  @override
  String? getCurrentUserId() => _auth.currentUser?.uid;
}
