import 'package:intl/intl.dart';

class SharedUtils {
  static String getYearMonthDayFormat(DateTime? date) =>
      date != null ? DateFormat('yyyy-MM-dd').format(date) : "";
}
