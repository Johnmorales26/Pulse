import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pulse/features/profile/domain/model/user_profile.dart';
import 'package:pulse/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileRepositoryImpl(this._firestore, this._storage);

  @override
  Future<UserProfile> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    final data = doc.data()!;

    return UserProfile(
      username: data['username'] as String? ?? '',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
    );
  }

  @override
  Future<void> updateProfilePicture(String uid, File imageFile) async {
    // Usa el UID como nombre de archivo para garantizar unicidad por usuario
    // y permitir la sobreescritura controlada en futuras actualizaciones.
    final storageRef = _storage.ref().child('profile_pictures/$uid.jpg');

    await storageRef.putFile(imageFile);
    final downloadUrl = await storageRef.getDownloadURL();

    await _firestore
        .collection('users')
        .doc(uid)
        .update({'photoUrl': downloadUrl});
  }
}