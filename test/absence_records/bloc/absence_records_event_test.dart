import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testAbsenceRecordsEvent();
}

void testAbsenceRecordsEvent() {
  group('AbsenceRecordsEventTest tests', () {
    test('AbsenceRecordsEvent test', () {
      AbsenceRecordsEvent event = AbsenceRecordsEvent();
      expect(event.props, []);
    });

    test('UpdateRequestTypeFilterEvent test', () {
      UpdateRequestTypeFilterEvent event = UpdateRequestTypeFilterEvent(
          requestTypeFilter: AbsenceRequestType.vacation);
      expect(event.props, [AbsenceRequestType.vacation]);
    });

    test('UpdateDateFilterEvent test', () {
      DateTime date = DateTime.now();
      UpdateDateFilterEvent event = UpdateDateFilterEvent(dateFilter: date);
      expect(event.props, [date]);
    });
  });
}
