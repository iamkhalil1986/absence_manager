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
  late final AbsenceRecordsService _absenceRecordsService;
  late final MemberRecordsService _memberRecordsService;

  final List<AbsenceState> _allAbsenceRecords = [];
  final int _pageLimit = 10;

  AbsenceRecordsBloc(
      {AbsenceRecordsService? absenceRecordsService,
      MemberRecordsService? memberRecordsService})
      : super(const AbsenceRecordsState()) {
    _absenceRecordsService = absenceRecordsService ?? AbsenceRecordsService();
    _memberRecordsService = memberRecordsService ?? MemberRecordsService();

    on<AbsenceRecordsEvent>(
      absenceRecordsRequestHandler,
    );
  }

  Future<void> absenceRecordsRequestHandler(
    AbsenceRecordsEvent event,
    Emitter<AbsenceRecordsState> emit,
  ) async {
    if (event is FetchAllRecordsEvent) {
      emit(AbsenceRecordsLoadingState());
      await _fetchAllRecords(emit);
    } else if (event is FetchPaginatedRecordsEvent) {
      _sendPaginatedAbsenceRecords(emit);
    }
  }

  Future<void> _fetchAllRecords(Emitter<AbsenceRecordsState> emit) async {
    final membersResponse = await _memberRecordsService.executeService();
    if (membersResponse is MemberRecordsResponseModel) {
      final absenceRecords = await _absenceRecordsService.executeService();
      if (absenceRecords is AbsenceRecordsResponseModel) {
        for (AbsenceResponseModel record in absenceRecords.records) {
          MemberResponseModel? member =
              _getMemberDetailsForRecord(record, membersResponse.members);
          if (member != null) {
            _allAbsenceRecords.add(AbsenceState(
                name: member.name,
                type: _getRequestType(type: record.type),
                startDate: DateTime.parse(record.startDate),
                endDate: DateTime.parse(record.endDate),
                memberNote: record.memberNote,
                status: _getAbsenceStatus(
                    confirmedAt: record.confirmedAt,
                    rejectedAt: record.rejectedAt),
                admitterNote: record.admitterNote));
          }
        }
        _sendPaginatedAbsenceRecords(emit);
      } else {
        emit(AbsenceRecordsErrorState());
      }
    } else {
      emit(AbsenceRecordsErrorState());
    }
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
    return confirmedAt != null
        ? AbsenceStatusType.confirmed
        : rejectedAt != null
            ? AbsenceStatusType.rejected
            : AbsenceStatusType.requested;
  }

  void _sendPaginatedAbsenceRecords(Emitter<AbsenceRecordsState> emit) {
    if (state.currentAbsenceRecordsCount < _allAbsenceRecords.length) {
      List<AbsenceState> paginatedRecords = [];
      for (int i = state.currentAbsenceRecordsCount;
          i < (_pageLimit + state.currentAbsenceRecordsCount) &&
              i < _allAbsenceRecords.length;
          i++) {
        paginatedRecords.add(_allAbsenceRecords[i]);
      }
      emit(state.copyWith(
          totalAbsenceRecordsCount: _allAbsenceRecords.length,
          currentAbsenceRecordsCount:
              (state.currentAbsenceRecordsCount + paginatedRecords.length),
          records: [...state.records, ...paginatedRecords]));
    }
  }
}
