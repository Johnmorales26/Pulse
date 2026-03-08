import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/core/auth/domain/usecases/get_current_user_id_use_case.dart';
import 'package:pulse/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:pulse/features/profile/domain/usecases/sign_out_use_case.dart';
import 'package:pulse/features/profile/domain/usecases/update_profile_picture_use_case.dart';

import 'profile_intent.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileIntent, ProfileState> {
  final SignOutUseCase _signOutUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateProfilePictureUseCase _updateProfilePictureUseCase;
  final GetCurrentUserIdUseCase _getCurrentUserIdUseCase;

  ProfileBloc(
    this._signOutUseCase,
    this._getUserProfileUseCase,
    this._updateProfilePictureUseCase,
    this._getCurrentUserIdUseCase,
  ) : super(ProfileInitial()) {
    on<LoadProfileIntent>(_onLoadProfile);
    on<SignOutIntent>(_onSignOut);
    on<ChangeProfilePictureIntent>(_onChangeProfilePicture);
  }

  Future<void> _onLoadProfile(
    LoadProfileIntent intent,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final uid = _getCurrentUserIdUseCase();
      if (uid == null) {
        emit(ProfileError('No hay sesión activa.'));
        return;
      }
      final profile = await _getUserProfileUseCase(uid);
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('No se pudieron cargar los datos del perfil.'));
    }
  }

  Future<void> _onChangeProfilePicture(
    ChangeProfilePictureIntent intent,
    Emitter<ProfileState> emit,
  ) async {
    final currentProfile =
        state is ProfileLoaded ? (state as ProfileLoaded).profile : null;
    if (currentProfile == null) return;

    emit(ProfilePictureUploading(currentProfile));
    try {
      final uid = _getCurrentUserIdUseCase()!;
      await _updateProfilePictureUseCase(uid, intent.image);
      final updated = await _getUserProfileUseCase(uid);
      emit(ProfileLoaded(updated));
    } catch (e) {
      emit(ProfileError('No se pudo actualizar la foto. Intenta de nuevo.'));
      emit(ProfileLoaded(currentProfile));
    }
  }

  Future<void> _onSignOut(
    SignOutIntent intent,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await _signOutUseCase();
      emit(ProfileSignOutSuccess());
    } catch (e) {
      emit(ProfileError('No se pudo cerrar la sesión. Intenta de nuevo.'));
    }
  }
}
