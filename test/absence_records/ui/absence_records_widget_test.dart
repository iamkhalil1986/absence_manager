import 'package:absence_manager/absence_records/absence_records_strings.dart';
import 'package:absence_manager/absence_records/absence_records_widget_keys.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/ui/absence_record_detail_widget.dart';
import 'package:absence_manager/absence_records/ui/absence_records_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock_data_provider.dart';

void main() {
  testAbsenceRecordsWidget();
}

void testAbsenceRecordsWidget() {
  group('AbsenceRecordsWidget tests', () {
    setUpAll(() {
      registerFallbackValue(MockRoute());
    });

    testWidgets(
        'Verify that the AbsenceRecordsWidget correctly displays a list of absence records, and when a record is tapped, it navigates to the details page displaying the corresponding record\'s details.',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<AbsenceRecordsBloc>(
            create: (_) =>
                MockAbsenceRecordsBloc.withRecords(), //AbsenceRecordsBloc(),
            child: AbsenceRecordsWidget()),
      ));
      await tester.pumpAndSettle();

      expect(find.text("Showing 3 of 3"), findsOneWidget);

      Finder dateFilterTag =
          find.byKey(AbsenceRecordsWidgetKeys.dateFilterTagKey);
      expect(dateFilterTag, findsOneWidget);

      Finder requestTypeFilterTag =
          find.byKey(AbsenceRecordsWidgetKeys.requestTypeFilterTagKey);
      expect(requestTypeFilterTag, findsOneWidget);

      //3 records displayed on the screen
      expect(find.byType(ListTile), findsNWidgets(3));

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();
      //Validate the details
      expect(find.byType(AbsenceRecordDetailWidget), findsOneWidget);
    });

    testWidgets(
        'Verify that the AbsenceRecordsWidget correctly displays an error message when the service fails to fetch absence records.',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<AbsenceRecordsBloc>(
            create: (_) =>
                MockAbsenceRecordsBloc.withError(), //AbsenceRecordsBloc(),
            child: AbsenceRecordsWidget()),
      ));
      await tester.pumpAndSettle();
      expect(find.text(AbsenceRecordsStrings.technicalDifficulties),
          findsOneWidget);
    });

    testWidgets(
        'Verify that the AbsenceRecordsWidget correctly displays no available records message.',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BlocProvider<AbsenceRecordsBloc>(
            create: (_) =>
                MockAbsenceRecordsBloc.withNoRecords(), //AbsenceRecordsBloc(),
            child: AbsenceRecordsWidget()),
      ));
      await tester.pumpAndSettle();
      expect(find.text(AbsenceRecordsStrings.noAbsenceRecordsMessage),
          findsOneWidget);
    });

    testWidgets(
        'Verify that the filter options are correctly toggled when the user taps on the filter buttons in the AbsenceRecordsWidget.',
        (tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(MaterialApp(
        navigatorObservers: [mockObserver],
        home: BlocProvider<AbsenceRecordsBloc>(
            create: (_) =>
                MockAbsenceRecordsBloc.withRecords(), //AbsenceRecordsBloc(),
            child: Navigator(onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                  builder: (context) => const AbsenceRecordsWidget());
            })),
      ));
      await tester.pumpAndSettle();

      Finder dateFilterTag =
          find.byKey(AbsenceRecordsWidgetKeys.dateFilterTagKey);
      expect(dateFilterTag, findsOneWidget);
      await tester.tap(dateFilterTag);
      await tester.pumpAndSettle();

      Finder requestTypeFilterTag =
          find.byKey(AbsenceRecordsWidgetKeys.requestTypeFilterTagKey);
      expect(requestTypeFilterTag, findsOneWidget);
      await tester.tap(requestTypeFilterTag);
      await tester.pumpAndSettle();

      Finder filterButton =
          find.byKey(AbsenceRecordsWidgetKeys.appBarFilterButtonKey);
      expect(filterButton, findsOneWidget);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();
      // Verify that Navigator.pop was called once.
      verify(() => mockObserver.didPush(any(), any())).called(1);
    });
  });
}
