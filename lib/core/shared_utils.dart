import 'package:intl/intl.dart';

class SharedUtils {
  static String getYearMonthDayFormat(DateTime? date) =>
      date != null ? DateFormat('yyyy-MM-dd').format(date) : "";
}

extension CapitalizeFirstLetter on String {
  String get capitalizeFirst {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}
