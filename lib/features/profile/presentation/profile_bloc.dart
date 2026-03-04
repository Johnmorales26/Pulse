import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pulse/features/profile/domain/usecases/sign_out_use_case.dart';

import 'profile_intent.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileIntent, ProfileState> {
  final SignOutUseCase _signOutUseCase;
  final Logger _logger;

  ProfileBloc(this._signOutUseCase, this._logger) : super(ProfileInitial()) {
    on<SignOutIntent>(_onSignOut);
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
      _logger.e('Error al cerrar sesión: $e');
      emit(ProfileError('No se pudo cerrar la sesión. Intenta de nuevo.'));
    }
  }
}