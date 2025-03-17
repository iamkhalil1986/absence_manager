import 'package:absence_manager/absence_records/absence_records_strings.dart';
import 'package:absence_manager/absence_records/absence_records_widget_keys.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/ui/absence_records_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock_data_provider.dart';

void main() {
  testAbsenceRecordsFilterWidget();
}

void testAbsenceRecordsFilterWidget() {
  group('AbsenceRecordsFilterWidget tests', () {
    setUpAll(() {
      registerFallbackValue(MockRoute());
    });

    testWidgets(
        'Verify that the correct form validation error messages are displayed when the user clicks the submit button without entering any filter criteria.',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<AbsenceRecordsBloc>(
            create: (_) =>
                MockAbsenceRecordsBloc.forFilter(), //AbsenceRecordsBloc(),
            child: AbsenceRecordsFilterWidget()),
      ));

      await tester.pumpAndSettle();
      expect(
          find.text(AbsenceRecordsStrings.absenceRecordFilter), findsOneWidget);

      Finder submitCTA =
          find.widgetWithText(ElevatedButton, AbsenceRecordsStrings.submit);
      expect(submitCTA, findsOneWidget);

      await tester.tap(submitCTA);
      await tester.pumpAndSettle();
      expect(find.text(AbsenceRecordsStrings.formValidationErrorMessage),
          findsNWidgets(2));
    });

    testWidgets(
        'Verify that the Submit button functions correctly when valid filter criteria are entered, and the appropriate action is triggered.',
        (tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(MaterialApp(
        navigatorObservers: [mockObserver],
        home: BlocProvider<AbsenceRecordsBloc>(
            create: (_) =>
                MockAbsenceRecordsBloc.forFilter(), //AbsenceRecordsBloc(),
            child: AbsenceRecordsFilterWidget()),
      ));

      await tester.pumpAndSettle(Duration(milliseconds: 300));
      expect(
          find.text(AbsenceRecordsStrings.absenceRecordFilter), findsOneWidget);

      Finder requestTypeDropdown =
          find.byKey(AbsenceRecordsWidgetKeys.requestTypeFieldKey);
      expect(requestTypeDropdown, findsOneWidget);
      //Tap on dropdown field to selected request type
      await tester.tap(requestTypeDropdown);
      await tester.pump();
      //Select request type as SICKNESS
      await tester.tap(find.text("SICKNESS").last);
      await tester.pump();

      Finder datePicker = find.byKey(AbsenceRecordsWidgetKeys.dateFieldKey);
      expect(datePicker, findsOneWidget);
      //Tap on date picker field
      await tester.tap(datePicker);
      await tester.pump();
      //Tap on OK button to select the date
      await tester.tap(find.text("OK"));
      await tester.pump();

      Finder submitCTA = find.byKey(AbsenceRecordsWidgetKeys.submitButtonKey);
      expect(submitCTA, findsOneWidget);

      await tester.tap(submitCTA);
      await tester.pumpAndSettle();
      // Verify that Navigator.pop was called once.
      verify(() => mockObserver.didPop(any(), any())).called(2);
    });

    testWidgets(
        'Verify that the Clear Filters button functions correctly, and the appropriate action is triggered.',
        (tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(MaterialApp(
        navigatorObservers: [mockObserver],
        home: BlocProvider<AbsenceRecordsBloc>(
            create: (_) =>
                MockAbsenceRecordsBloc.forFilter(), //AbsenceRecordsBloc(),
            child: AbsenceRecordsFilterWidget()),
      ));

      await tester.pumpAndSettle(Duration(milliseconds: 300));
      expect(
          find.text(AbsenceRecordsStrings.absenceRecordFilter), findsOneWidget);

      Finder clearFiltersCTA =
          find.byKey(AbsenceRecordsWidgetKeys.clearFilterButtonKey);
      expect(clearFiltersCTA, findsOneWidget);

      await tester.tap(clearFiltersCTA);
      await tester.pumpAndSettle();
      // Verify that Navigator.pop was called once.
      verify(() => mockObserver.didPop(any(), any())).called(1);
    });
  });
}
