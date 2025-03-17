import 'package:absence_manager/absence_records/absence_records_widget_keys.dart';
import 'package:absence_manager/absence_records/ui/absence_record_detail_widget.dart';
import 'package:absence_manager/absence_records/ui/absence_records_filter_widget.dart';
import 'package:absence_manager/absence_records/ui/absence_records_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:absence_manager/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test end to end flow', (WidgetTester tester) async {
    //Launch the app
    app.main();
    // Wait for the app to settle
    await tester.pumpAndSettle();

    //Test create list and detail flow
    await _testAbsenceListAndDetailFlow(tester);

    //Test filter flow
    await _testFilterFlow(tester);
  });
}

Future<void> _testAbsenceListAndDetailFlow(WidgetTester tester) async {
  expect(find.text("Showing 10 of 42"), findsOneWidget);

  // Find the ListView
  final listViewFinder = find.byType(ListView);

  // Ensure the ListView is present
  expect(listViewFinder, findsOneWidget);

  final listItems = find.byType(ListTile);
  expect(listItems, findsWidgets);

  //Tap on first record to view the details
  await tester.tap(listItems.first);

  // Wait for animations to complete
  await tester.pumpAndSettle();

  //Validate the details
  expect(find.byType(AbsenceRecordDetailWidget), findsOneWidget);
  await Future.delayed(Duration(seconds: 1));

  //Close details view
  // Get the size of the screen to calculate the top of the screen.
  final screenSize = tester.view.physicalSize;
  // Calculate a point at the top of the screen
  final topCenter = Offset(screenSize.height / 4, 0);
  // Perform the tap at the calculated position (top-center of the screen).
  await tester.tapAt(topCenter);

  // Wait for animations to complete
  await tester.pumpAndSettle();

  // Scroll until the end of the ListView
  await tester.ensureVisible(listItems.last);
  await Future.delayed(Duration(seconds: 1));

  // Wait for animations to complete
  await tester.pumpAndSettle();

  //Verify next of records loaded as well
  expect(find.text("Showing 20 of 42"), findsOneWidget);
}

Future<void> _testFilterFlow(WidgetTester tester) async {
  Finder filterButton =
      find.byKey(AbsenceRecordsWidgetKeys.appBarFilterButtonKey);
  expect(filterButton, findsOneWidget);

  //Tap on filter CTA
  await tester.tap(filterButton);

  // Wait for animations to complete
  await tester.pumpAndSettle();

  //Verify filter screen loaded properly
  expect(find.byType(AbsenceRecordsFilterWidget), findsOneWidget);

  Finder requestTypeField =
      find.byKey(AbsenceRecordsWidgetKeys.requestTypeFieldKey);
  expect(requestTypeField, findsOneWidget);
  Finder dateField = find.byKey(AbsenceRecordsWidgetKeys.dateFieldKey);
  expect(dateField, findsOneWidget);
  Finder submitButton = find.byKey(AbsenceRecordsWidgetKeys.submitButtonKey);
  expect(submitButton, findsOneWidget);

  //Tap on dropdown field to selected request type
  await tester.tap(requestTypeField);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));
  //Select option
  await tester.tap(find.text("SICKNESS").last);
  await tester.pumpAndSettle();
  await Future.delayed(Duration(seconds: 1));

  //Tap on submit button to create a expense record
  await tester.tap(submitButton);
  await tester.pumpAndSettle();
  expect(find.byType(AbsenceRecordsWidget), findsOneWidget);
  await Future.delayed(Duration(seconds: 3));

  Finder requestTypeFilterTag =
      find.byKey(AbsenceRecordsWidgetKeys.requestTypeFilterTagKey);
  expect(requestTypeFilterTag, findsOneWidget);
  await tester.tap(requestTypeFilterTag);
  await tester.pumpAndSettle();
  expect(find.text("Showing 10 of 42"), findsOneWidget);
  await Future.delayed(Duration(seconds: 3));
}
