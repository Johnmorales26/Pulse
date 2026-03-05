import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  /// Formatea la fecha respetando el idioma del sistema.
  /// El [pattern] viene del ARB (commentDateFormat) y el [locale] del contexto
  /// via Localizations.localeOf(context).languageCode.
  ///
  /// ES → "03 mar 2026 · 14:32"
  /// EN → "Mar 03, 2026 · 14:32"
  String toDisplayFormat(String pattern, [String? locale]) =>
      DateFormat(pattern, locale).format(this);
}
