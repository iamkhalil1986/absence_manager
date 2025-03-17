import 'package:absence_manager/absence_records/bloc/absence_records_state.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testAbsenceRecordsState();
}

void testAbsenceRecordsState() {
  group('AbsenceRecordsState tests', () {
    test('AbsenceRecordsState copyWith test', () {
      AbsenceRecordsState initialState = AbsenceRecordsState();
      expect(initialState.props, [0, 0, null, null, []]);

      //Call copyWith without changing any properties
      AbsenceRecordsState newState = initialState.copyWith();
      expect(initialState, newState);

      //Now update any property with copyWith and validate new value
      newState = initialState.copyWith(currentAbsenceRecordsCount: 10);
      expect(newState.currentAbsenceRecordsCount, 10);
    });
  });
}
