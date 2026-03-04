import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pulse/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:pulse/features/auth/domain/usecases/sign_up_use_case.dart';

import 'auth_intent.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthIntent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final Logger _logger;

  AuthBloc(this._signInUseCase, this._signUpUseCase, this._logger)
    : super(AuthInitial()) {
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
      _logger.e('Error inesperado en sign-in: $e');
      emit(AuthError('Error inesperado. Intenta de nuevo.'));
    }
  }

  Future<void> _onSignUp(
    SignUpIntent intent,
    Emitter<AuthState> emit,
  ) async {
    // Validaciones locales — se resuelven antes de hacer cualquier llamada de red.
    if (intent.username.trim().isEmpty) {
      emit(AuthError('El nombre de usuario es obligatorio.'));
      return;
    }
    if (!intent.email.contains('@')) {
      emit(AuthError('El correo electrónico no es válido.'));
      return;
    }
    if (intent.password.length < 6) {
      emit(AuthError('La contraseña debe tener al menos 6 caracteres.'));
      return;
    }
    if (intent.password != intent.confirmPassword) {
      emit(AuthError('Las contraseñas no coinciden. Inténtalo de nuevo.'));
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
      _logger.e('Error inesperado en sign-up: $e');
      emit(AuthError('Error inesperado. Intenta de nuevo.'));
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-email' => 'El correo electrónico no es válido.',
      'user-disabled' => 'Esta cuenta ha sido deshabilitada.',
      'user-not-found' => 'No existe una cuenta con este correo.',
      'wrong-password' || 'invalid-credential' => 'Contraseña incorrecta.',
      'email-already-in-use' => 'Este correo ya está registrado.',
      'weak-password' => 'La contraseña debe tener al menos 6 caracteres.',
      'too-many-requests' => 'Demasiados intentos. Espera un momento.',
      'network-request-failed' => 'Sin conexión a internet.',
      _ => 'Error de autenticación. Intenta de nuevo.',
    };
  }
}