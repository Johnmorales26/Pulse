import 'package:pulse/features/profile/domain/model/user_profile.dart';
import 'package:pulse/features/profile/domain/repository/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository _repository;

  GetUserProfileUseCase(this._repository);

  Future<UserProfile> call(String uid) => _repository.getUserProfile(uid);
}