import 'package:intl/intl.dart';

extension DateTimeFormatting on DateTime {
  String toDisplayFormat(String pattern, [String? locale]) =>
      DateFormat(pattern, locale).format(this);
}
