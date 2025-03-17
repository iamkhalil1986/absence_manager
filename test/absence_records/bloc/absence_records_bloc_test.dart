import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_bloc.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_state.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';

import '../mock_data_provider.dart';

void main() {
  testAbsenceRecordsBloc();
}

void testAbsenceRecordsBloc() {
  group('AbsenceRecordsBloc tests', () {
    AbsenceRecordsState recordsState = AbsenceRecordsState(
        currentAbsenceRecordsCount: 1,
        totalAbsenceRecordsCount: 1,
        dateFilter: null,
        requestTypeFilter: null,
        records: [
          AbsenceState(
              name: "Max",
              type: AbsenceRequestType.sickness,
              startDate: DateTime(2021, 01, 13),
              endDate: DateTime(2021, 01, 13),
              status: AbsenceStatusType.confirmed,
              admitterNote: "",
              memberNote: "")
        ]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test FetchAllRecordsEvent to return FetchAllRecordsEvent when both services returns valid response',
        build: () => AbsenceRecordsBloc(
            absenceRecordsService: MockAbsenceRecordsService.withSingleRecord(),
            memberRecordsService: MockMemberRecordsService.withSingleRecord()),
        act: (bloc) => bloc.add(FetchAllRecordsEvent()),
        expect: () => [AbsenceRecordsInitialLoadingState(), recordsState]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test FetchAllRecordsEvent to return AbsenceRecordsErrorState when MemberRecordsService fails',
        build: () => AbsenceRecordsBloc(
            absenceRecordsService: MockAbsenceRecordsService.withSingleRecord(),
            memberRecordsService: MockMemberRecordsService.withFailure()),
        act: (bloc) => bloc.add(FetchAllRecordsEvent()),
        expect: () =>
            [AbsenceRecordsInitialLoadingState(), AbsenceRecordsErrorState()]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test FetchAllRecordsEvent to return AbsenceRecordsErrorState when AbsenceRecordsService fails',
        build: () => AbsenceRecordsBloc(
            absenceRecordsService: MockAbsenceRecordsService.withFailure(),
            memberRecordsService: MockMemberRecordsService.withSingleRecord()),
        act: (bloc) => bloc.add(FetchAllRecordsEvent()),
        expect: () =>
            [AbsenceRecordsInitialLoadingState(), AbsenceRecordsErrorState()]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test FetchPaginatedRecordsEvent',
        build: () =>
            AbsenceRecordsBloc(allAbsenceRecords: recordsState.records),
        seed: () => recordsState.copyWith(
            currentAbsenceRecordsCount: 0,
            requestTypeFilter: AbsenceRequestType.sickness,
            dateFilter: DateTime(2021, 01, 13),
            records: []),
        act: (bloc) {
          bloc.add(FetchPaginatedRecordsEvent());
        },
        expect: () => [
              recordsState.copyWith(
                  requestTypeFilter: AbsenceRequestType.sickness,
                  dateFilter: DateTime(2021, 01, 13))
            ]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test AbsenceRecordsWithFilterEvent with AbsenceRequestType.sickness only filter',
        build: () =>
            AbsenceRecordsBloc(allAbsenceRecords: recordsState.records),
        seed: () => recordsState.copyWith(
            currentAbsenceRecordsCount: 0,
            requestTypeFilter: AbsenceRequestType.sickness,
            records: []),
        act: (bloc) {
          bloc.add(AbsenceRecordsWithFilterEvent());
        },
        expect: () => [
              AbsenceRecordsState(
                  requestTypeFilter: AbsenceRequestType.sickness),
              recordsState.copyWith(
                  requestTypeFilter: AbsenceRequestType.sickness)
            ]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test AbsenceRecordsWithFilterEvent with only DateTime(2021, 01, 13) filter',
        build: () =>
            AbsenceRecordsBloc(allAbsenceRecords: recordsState.records),
        seed: () => recordsState.copyWith(
            currentAbsenceRecordsCount: 0,
            dateFilter: DateTime(2021, 01, 13),
            records: []),
        act: (bloc) {
          bloc.add(AbsenceRecordsWithFilterEvent());
        },
        expect: () => [
              AbsenceRecordsState(dateFilter: DateTime(2021, 01, 13)),
              recordsState.copyWith(dateFilter: DateTime(2021, 01, 13))
            ]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test UpdateRequestTypeFilterEvent',
        build: () => AbsenceRecordsBloc(),
        act: (bloc) {
          bloc.add(UpdateRequestTypeFilterEvent(
              requestTypeFilter: AbsenceRequestType.sickness));
        },
        expect: () => [
              AbsenceRecordsState(
                  requestTypeFilter: AbsenceRequestType.sickness)
            ]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test UpdateDateFilterEvent',
        build: () => AbsenceRecordsBloc(),
        act: (bloc) {
          bloc.add(UpdateDateFilterEvent(dateFilter: DateTime(2021, 01, 13)));
        },
        expect: () =>
            [AbsenceRecordsState(dateFilter: DateTime(2021, 01, 13))]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test ClearDateFilterEvent',
        build: () => AbsenceRecordsBloc(),
        seed: () => AbsenceRecordsState(dateFilter: DateTime(2021, 01, 13)),
        act: (bloc) {
          bloc.add(ClearDateFilterEvent());
        },
        expect: () => [AbsenceRecordsState()]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test ClearRequestTypeFilterEvent',
        build: () => AbsenceRecordsBloc(),
        seed: () =>
            AbsenceRecordsState(requestTypeFilter: AbsenceRequestType.sickness),
        act: (bloc) {
          bloc.add(ClearRequestTypeFilterEvent());
        },
        expect: () => [AbsenceRecordsState()]);

    blocTest<AbsenceRecordsBloc, AbsenceRecordsState>(
        'AbsenceRecordsBloc - Test ClearAllFiltersEvent',
        build: () => AbsenceRecordsBloc(),
        seed: () => AbsenceRecordsState(
            requestTypeFilter: AbsenceRequestType.sickness,
            dateFilter: DateTime(2021, 01, 13)),
        act: (bloc) {
          bloc.add(ClearAllFiltersEvent());
        },
        expect: () => [AbsenceRecordsState()]);
  });
}
