// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pulse';

  @override
  String get loginTitle => 'Bienvenido de vuelta';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get signUpTitle => 'Crear cuenta';

  @override
  String get signUpButton => 'Registrarse';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get usernameLabel => 'Nombre de usuario';

  @override
  String get confirmPasswordLabel => 'Confirmar contraseña';

  @override
  String get noAccountPrompt => '¿No tienes cuenta?';

  @override
  String get signUpLink => 'Regístrate';

  @override
  String get hasAccountPrompt => '¿Ya tienes cuenta?';

  @override
  String get signInLink => 'Inicia sesión';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get savedPlacesOption => 'Mis lugares guardados';

  @override
  String get settingsOption => 'Configuración';

  @override
  String get signOutButton => 'Cerrar Sesión';

  @override
  String get noName => 'Sin nombre';

  @override
  String get saveButton => 'Guardar';

  @override
  String get savedButton => 'Guardado';

  @override
  String get removeSavedTooltip => 'Eliminar de guardados';

  @override
  String get addSavedTooltip => 'Guardar lugar';

  @override
  String get navigateButton => 'Ir';

  @override
  String get navigateTooltip => 'Navegar';

  @override
  String get commentHint => 'Escribe un comentario...';

  @override
  String get commentAdded => 'Comentario añadido';

  @override
  String get commentError => 'Error al añadir comentario';

  @override
  String get retryButton => 'Reintentar';

  @override
  String get openWith => 'Abrir con';

  @override
  String get noMapsInstalled =>
      'No tienes ninguna aplicación de mapas instalada.';

  @override
  String get noSavedPlaces => 'Aún no tienes lugares guardados.';

  @override
  String get signInRequired =>
      'Debes iniciar sesión para realizar esta acción.';

  @override
  String get signInToSave => 'Debes iniciar sesión para guardar lugares.';

  @override
  String get saveFailed => 'No se pudo actualizar la lista de guardados.';

  @override
  String get loadPlaceError => 'Error al cargar el lugar';

  @override
  String get authErrorWrongCredentials => 'Usuario o contraseña incorrectos.';

  @override
  String get authErrorEmailInUse => 'Este correo ya está registrado.';

  @override
  String get authErrorWeakPassword =>
      'La contraseña debe tener al menos 6 caracteres.';

  @override
  String get authErrorPasswordMismatch => 'Las contraseñas no coinciden.';

  @override
  String get authErrorEmptyUsername =>
      'El nombre de usuario no puede estar vacío.';

  @override
  String get authErrorInvalidEmail => 'Ingresa un correo electrónico válido.';

  @override
  String get addPlaceTitle => 'Nuevo lugar';

  @override
  String get placeNameLabel => 'Nombre';

  @override
  String get placeNameHint => 'Ingresa el nombre del lugar';

  @override
  String get placeDescriptionLabel => 'Descripción';

  @override
  String get placeDescriptionHint => 'Ingresa una descripción';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get selectCategoryTitle => 'Seleccionar categoría';

  @override
  String get savePlaceButton => 'Guardar lugar';

  @override
  String get savingLabel => 'Guardando...';

  @override
  String get placeSavedSuccess => 'Lugar guardado correctamente.';

  @override
  String get unknownError => 'Ocurrió un error desconocido.';

  @override
  String get emailHint => 'ejemplo@correo.com';

  @override
  String get passwordHint => 'Mín. 6 caracteres';

  @override
  String get usernameHint => 'Usuario de Pulse';

  @override
  String get forgotPasswordButton => '¿Olvidaste tu contraseña?';

  @override
  String get authErrorUserDisabled => 'Esta cuenta ha sido deshabilitada.';

  @override
  String get authErrorTooManyRequests =>
      'Demasiados intentos. Espera un momento.';

  @override
  String get authErrorNetworkFailed => 'Sin conexión a internet.';

  @override
  String get authErrorGeneric => 'Error de autenticación. Intenta de nuevo.';

  @override
  String get myLocationTooltip => 'Centrar en mi ubicación';

  @override
  String get profileTooltip => 'Perfil';

  @override
  String mapLoadError(String error) {
    return 'No se pudo cargar el mapa: $error';
  }

  @override
  String get locationPermissionDenied =>
      'Permiso de ubicación denegado. Actívalo en Configuración.';

  @override
  String get openSettings => 'Abrir configuración';

  @override
  String get commentDateFormat => 'dd MMM yyyy · HH:mm';

  @override
  String get changeProfilePicture => 'Cambiar foto de perfil';

  @override
  String get cameraOption => 'Tomar una foto';

  @override
  String get galleryOption => 'Elegir de la galería';

  @override
  String savedPlacesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lugares guardados',
      one: '1 lugar guardado',
      zero: 'Sin lugares guardados',
    );
    return '$_temp0';
  }

  @override
  String get filterLabel => 'Filtrar';

  @override
  String get loadingMap => 'Configurando Mapa';

  @override
  String get unknownCategory => 'Desconocido';
}
