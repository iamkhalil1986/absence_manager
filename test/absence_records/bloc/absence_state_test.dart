import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testAbsenceState();
}

void testAbsenceState() {
  group('AbsenceState tests', () {
    test('AbsenceState props test', () {
      DateTime date = DateTime.now();
      AbsenceState state = AbsenceState(
          name: "name",
          type: AbsenceRequestType.vacation,
          startDate: date,
          endDate: date,
          memberNote: "",
          status: AbsenceStatusType.requested,
          admitterNote: "");
      expect(state.props, [
        "name",
        AbsenceRequestType.vacation,
        date,
        date,
        "",
        AbsenceStatusType.requested,
        ""
      ]);
    });
  });
}
