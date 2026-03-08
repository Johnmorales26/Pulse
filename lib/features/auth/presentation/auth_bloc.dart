import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pulse/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:pulse/features/auth/domain/usecases/sign_up_use_case.dart';

import 'auth_intent.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthIntent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;

  AuthBloc(this._signInUseCase, this._signUpUseCase) : super(AuthInitial()) {
    on<SignInIntent>(_onSignIn);
    on<SignUpIntent>(_onSignUp);
  }

  Future<void> _onSignIn(
    SignInIntent intent,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _signInUseCase(email: intent.email, password: intent.password);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError('unknownError'));
    }
  }

  Future<void> _onSignUp(
    SignUpIntent intent,
    Emitter<AuthState> emit,
  ) async {
    if (intent.username.trim().isEmpty) {
      emit(AuthError('authErrorEmptyUsername'));
      return;
    }
    if (!intent.email.contains('@')) {
      emit(AuthError('authErrorInvalidEmail'));
      return;
    }
    if (intent.password.length < 6) {
      emit(AuthError('authErrorWeakPassword'));
      return;
    }
    if (intent.password != intent.confirmPassword) {
      emit(AuthError('authErrorPasswordMismatch'));
      return;
    }

    emit(AuthLoading());
    try {
      await _signUpUseCase(
        username: intent.username.trim(),
        email: intent.email.trim(),
        password: intent.password,
      );
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapFirebaseError(e)));
    } catch (e) {
      emit(AuthError('unknownError'));
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => 'authErrorInvalidEmail',
      'user-disabled' => 'authErrorUserDisabled',
      'user-not-found' || 'wrong-password' || 'invalid-credential' =>
        'authErrorWrongCredentials',
      'email-already-in-use' => 'authErrorEmailInUse',
      'weak-password' => 'authErrorWeakPassword',
      'too-many-requests' => 'authErrorTooManyRequests',
      'network-request-failed' => 'authErrorNetworkFailed',
      _ => 'authErrorGeneric',
    };
  }
}
