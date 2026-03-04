import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pulse/features/auth/domain/repository/user_auth_repository.dart';

class UserAuthRepositoryImpl implements UserAuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  UserAuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    // Solo autentica — el perfil en Firestore ya existe desde el registro.
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    // 1. Crea la cuenta en Firebase Auth.
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    // 2. Sincroniza el perfil en Firestore usando el UID como ID de documento.
    //    merge: true garantiza que si el documento ya existe (ej. reinstalación),
    //    no se sobreescriban campos como lugares creados por el usuario.
    await _firestore.collection('users').doc(uid).set(
      {
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();
}