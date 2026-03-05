import 'dart:io';

abstract class ProfileIntent {}

class LoadProfileIntent extends ProfileIntent {}

class SignOutIntent extends ProfileIntent {}

class ChangeProfilePictureIntent extends ProfileIntent {
  final File image;

  ChangeProfilePictureIntent(this.image);
}