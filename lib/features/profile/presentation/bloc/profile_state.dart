import 'package:pulse/features/profile/domain/model/user_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  ProfileLoaded(this.profile);
}

class ProfilePictureUploading extends ProfileState {
  final UserProfile profile;

  ProfilePictureUploading(this.profile);
}

class ProfileSignOutSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}