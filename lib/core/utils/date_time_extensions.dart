import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  /// Formatea la fecha con el patrón: dd MMM yyyy · HH:mm
  /// Ejemplo: 03 Mar 2026 · 14:32
  ///
  /// El separador · (U+00B7, punto medio) se escapa con comillas simples
  /// dentro del patrón de DateFormat para que no sea interpretado como
  /// un token de formato.
  String toDisplayFormat() => DateFormat("dd MMM yyyy '·' HH:mm").format(this);
}
