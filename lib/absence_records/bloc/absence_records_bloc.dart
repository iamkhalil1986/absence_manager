import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/api/absence_records_service.dart';
import 'package:absence_manager/absence_records/api/member_records_service.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_event.dart';
import 'package:absence_manager/absence_records/bloc/absence_records_state.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:absence_manager/absence_records/models/absence_records_response_model.dart';
import 'package:absence_manager/absence_records/models/absence_response_model.dart';
import 'package:absence_manager/absence_records/models/member_records_response_model.dart';
import 'package:absence_manager/absence_records/models/member_response_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

class AbsenceRecordsBloc
    extends Bloc<AbsenceRecordsEvent, AbsenceRecordsState> {
  final AbsenceRecordsService _absenceRecordsService;
  final MemberRecordsService _memberRecordsService;

  final List<AbsenceState> _allAbsenceRecords = [];
  final int _pageLimit = 10;

  AbsenceRecordsBloc({
    AbsenceRecordsService? absenceRecordsService,
    MemberRecordsService? memberRecordsService,
  })  : _absenceRecordsService =
            absenceRecordsService ?? AbsenceRecordsService(),
        _memberRecordsService = memberRecordsService ?? MemberRecordsService(),
        super(const AbsenceRecordsState()) {
    on<AbsenceRecordsEvent>(_absenceRecordsRequestHandler);
  }

  Future<void> _absenceRecordsRequestHandler(
    AbsenceRecordsEvent event,
    Emitter<AbsenceRecordsState> emit,
  ) async {
    if (event is FetchAllRecordsEvent) {
      emit(AbsenceRecordsInitialLoadingState());
      await _fetchAllRecords(emit);
    } else if (event is FetchPaginatedRecordsEvent) {
      _sendPaginatedAbsenceRecords(emit);
    } else if (event is AbsenceRecordsWithFilterEvent) {
      _applyFilterAndFetchRecords(event, emit);
    } else if (event is UpdateRequestTypeFilterEvent) {
      emit(state.copyWith(requestTypeFilter: event.requestTypeFilter));
    } else if (event is UpdateDateFilterEvent) {
      emit(state.copyWith(dateFilter: event.dateFilter));
    } else if (event is ClearDateFilterEvent ||
        event is ClearRequestTypeFilterEvent) {
      _clearFilterAndFetchRecords(emit, event);
    } else if (event is ClearAllFiltersEvent) {
      emit(AbsenceRecordsState());
      _sendPaginatedAbsenceRecords(emit);
    }
  }

  Future<void> _fetchAllRecords(Emitter<AbsenceRecordsState> emit) async {
    final membersResponse = await _memberRecordsService.executeService();
    if (membersResponse is MemberRecordsResponseModel) {
      final absenceRecords = await _absenceRecordsService.executeService();
      if (absenceRecords is AbsenceRecordsResponseModel) {
        _processFetchedAbsenceRecords(absenceRecords, membersResponse, emit);
      } else {
        emit(AbsenceRecordsErrorState());
      }
    } else {
      emit(AbsenceRecordsErrorState());
    }
  }

  void _processFetchedAbsenceRecords(
    AbsenceRecordsResponseModel absenceRecords,
    MemberRecordsResponseModel membersResponse,
    Emitter<AbsenceRecordsState> emit,
  ) {
    for (var record in absenceRecords.records) {
      final member =
          _getMemberDetailsForRecord(record, membersResponse.members);
      if (member != null) {
        _allAbsenceRecords.add(AbsenceState(
          name: member.name,
          type: _getRequestType(type: record.type),
          startDate: DateTime.parse(record.startDate),
          endDate: DateTime.parse(record.endDate),
          memberNote: record.memberNote,
          status: _getAbsenceStatus(
              confirmedAt: record.confirmedAt, rejectedAt: record.rejectedAt),
          admitterNote: record.admitterNote,
        ));
      }
    }
    _sendPaginatedAbsenceRecords(emit);
  }

  void _applyFilterAndFetchRecords(
      AbsenceRecordsWithFilterEvent event, Emitter<AbsenceRecordsState> emit) {
    emit(AbsenceRecordsState().copyWith(
        requestTypeFilter: state.requestTypeFilter,
        dateFilter: state.dateFilter));
    _sendPaginatedAbsenceRecords(emit);
  }

  void _clearFilterAndFetchRecords(Emitter<AbsenceRecordsState> emit, event) {
    if (event is ClearDateFilterEvent) {
      emit(AbsenceRecordsState()
          .copyWith(requestTypeFilter: state.requestTypeFilter));
    } else if (event is ClearRequestTypeFilterEvent) {
      emit(AbsenceRecordsState().copyWith(dateFilter: state.dateFilter));
    }
    _sendPaginatedAbsenceRecords(emit);
  }

  MemberResponseModel? _getMemberDetailsForRecord(
      AbsenceResponseModel absenceRecord, List<MemberResponseModel> members) {
    return members
        .firstWhereOrNull((member) => member.userId == absenceRecord.userId);
  }

  AbsenceRequestType _getRequestType({required String type}) {
    return type == AbsenceRequestType.sickness.type
        ? AbsenceRequestType.sickness
        : AbsenceRequestType.vacation;
  }

  AbsenceStatusType _getAbsenceStatus(
      {String? confirmedAt, String? rejectedAt}) {
    if (confirmedAt != null) return AbsenceStatusType.confirmed;
    return rejectedAt != null
        ? AbsenceStatusType.rejected
        : AbsenceStatusType.requested;
  }

  void _sendPaginatedAbsenceRecords(Emitter<AbsenceRecordsState> emit) {
    final filteredRecords = _allAbsenceRecords.where((record) {
      if (state.dateFilter != null && state.requestTypeFilter != null) {
        // Case 4: Both dateFilter and requestTypeFilter are not null
        return state.dateFilter!
                .isAfter(record.startDate.add(Duration(days: -1))) &&
            state.dateFilter!.isBefore(record.endDate.add(Duration(days: 1))) &&
            state.requestTypeFilter == record.type;
      } else if (state.dateFilter != null) {
        // Case 2: Only dateFilter is not null
        return state.dateFilter!
                .isAfter(record.startDate.add(Duration(days: -1))) &&
            state.dateFilter!.isBefore(record.endDate.add(Duration(days: 1)));
      } else if (state.requestTypeFilter != null) {
        // Case 3: Only requestTypeFilter is not null
        return state.requestTypeFilter == record.type;
      } else {
        // Case 1: Both filters are null (no filtering)
        return true;
      }
    }).toList();
    _sendPaginatedRecords(emit, filteredRecords);
  }

  void _sendPaginatedRecords(
      Emitter<AbsenceRecordsState> emit, List<AbsenceState> records) {
    if (state.currentAbsenceRecordsCount < records.length) {
      final paginatedRecords = records
          .skip(state.currentAbsenceRecordsCount)
          .take(_pageLimit)
          .toList();
      emit(state.copyWith(
        totalAbsenceRecordsCount: records.length,
        currentAbsenceRecordsCount:
            state.currentAbsenceRecordsCount + paginatedRecords.length,
        records: [...state.records, ...paginatedRecords],
      ));
    }
  }
}
