import 'dart:io';

import 'package:pulse/features/profile/domain/model/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile(String uid);
  Future<void> updateProfilePicture(String uid, File imageFile);
}