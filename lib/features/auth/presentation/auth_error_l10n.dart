import 'package:pulse/l10n/app_localizations.dart';

/// Convierte el código de clave emitido por [AuthBloc] en un mensaje
/// localizado listo para mostrar en la UI.
///
/// El BLoC emite códigos neutrales (ej. 'authErrorWrongCredentials')
/// para mantenerse libre de dependencias de la capa de presentación.
String localizeAuthError(String key, AppLocalizations l10n) {
  return switch (key) {
    'authErrorInvalidEmail' => l10n.authErrorInvalidEmail,
    'authErrorEmptyUsername' => l10n.authErrorEmptyUsername,
    'authErrorWeakPassword' => l10n.authErrorWeakPassword,
    'authErrorPasswordMismatch' => l10n.authErrorPasswordMismatch,
    'authErrorWrongCredentials' => l10n.authErrorWrongCredentials,
    'authErrorEmailInUse' => l10n.authErrorEmailInUse,
    'authErrorUserDisabled' => l10n.authErrorUserDisabled,
    'authErrorTooManyRequests' => l10n.authErrorTooManyRequests,
    'authErrorNetworkFailed' => l10n.authErrorNetworkFailed,
    'authErrorGeneric' => l10n.authErrorGeneric,
    _ => l10n.unknownError,
  };
}