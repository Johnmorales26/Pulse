import 'dart:io';

import 'package:pulse/features/profile/domain/repository/profile_repository.dart';

class UpdateProfilePictureUseCase {
  final ProfileRepository _repository;

  UpdateProfilePictureUseCase(this._repository);

  Future<void> call(String uid, File imageFile) =>
      _repository.updateProfilePicture(uid, imageFile);
}