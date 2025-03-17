import 'package:intl/intl.dart';

extension CapitalizeFirstLetter on String {
  String get capitalizeFirst {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

extension FormattedDateTime on DateTime {
  String get formattedDate {
    return DateFormat('yyyy-MM-dd').format(this);
  }
}
