import 'package:intl/intl.dart';

class SharedUtils {
  static String getYearMonthDayFormat(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);
}
