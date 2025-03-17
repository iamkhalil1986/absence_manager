import 'package:absence_manager/absence_records/absence_records_strings.dart';
import 'package:absence_manager/absence_records/ui/absence_record_detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_data_provider.dart';

void main() {
  testAbsenceRecordDetailWidget();
}

void testAbsenceRecordDetailWidget() {
  group('AbsenceRecordDetailWidget tests', () {
    testWidgets(
        'Test AbsenceRecordDetailWidget content displayed with duration as 1',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AbsenceRecordDetailWidget(
          status: AbsenceRecordsStrings.confirmed,
          statusColor: Colors.green,
          statusIcon: Icons.check_circle,
          record: MockDataProvider.sicknessConfirmedRecord,
          duration: 1,
        ),
      ));

      await tester.pumpAndSettle();
      expect(find.text(AbsenceRecordsStrings.confirmed), findsOneWidget);
      //Verify Category requested
      expect(find.text("Sickness"), findsOneWidget);
      //Verify Duration
      expect(find.text("1 day"), findsOneWidget);
      //Verify only single date is visible
      expect(find.text("Date:"), findsOneWidget);
    });

    testWidgets(
        'Test AbsenceRecordDetailWidget content displayed with duration as 2',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AbsenceRecordDetailWidget(
          status: AbsenceRecordsStrings.confirmed,
          statusColor: Colors.green,
          statusIcon: Icons.check_circle,
          record: MockDataProvider.sicknessConfirmedRecord,
          duration: 2,
        ),
      ));

      await tester.pumpAndSettle();
      expect(find.text(AbsenceRecordsStrings.confirmed), findsOneWidget);
      //Verify Category requested
      expect(find.text("Sickness"), findsOneWidget);
      //Verify Duration
      expect(find.text("2 days"), findsOneWidget);
      //Verify only single date is visible
      expect(find.text("Start Date:"), findsOneWidget);
      expect(find.text("End Date:"), findsOneWidget);
    });
  });
}
