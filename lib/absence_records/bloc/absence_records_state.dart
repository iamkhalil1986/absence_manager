import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:equatable/equatable.dart';

class AbsenceRecordsState extends Equatable {
  final int currentAbsenceRecordsCount;
  final int totalAbsenceRecordsCount;
  final DateTime? dateFilter;
  final AbsenceRequestType? requestTypeFilter;
  final List<AbsenceState> records;

  const AbsenceRecordsState(
      {this.currentAbsenceRecordsCount = 0,
      this.totalAbsenceRecordsCount = 0,
      this.dateFilter,
      this.requestTypeFilter,
      this.records = const []});

  AbsenceRecordsState copyWith(
      {int? currentAbsenceRecordsCount,
      int? totalAbsenceRecordsCount,
      DateTime? dateFilter,
      AbsenceRequestType? requestTypeFilter,
      List<AbsenceState>? records}) {
    return AbsenceRecordsState(
        currentAbsenceRecordsCount:
            currentAbsenceRecordsCount ?? this.currentAbsenceRecordsCount,
        totalAbsenceRecordsCount:
            totalAbsenceRecordsCount ?? this.totalAbsenceRecordsCount,
        dateFilter: dateFilter ?? this.dateFilter,
        requestTypeFilter: requestTypeFilter ?? this.requestTypeFilter,
        records: records ?? this.records);
  }

  @override
  List<Object?> get props => [
        currentAbsenceRecordsCount,
        totalAbsenceRecordsCount,
        dateFilter,
        requestTypeFilter,
        records
      ];
}

class AbsenceRecordsInitialLoadingState extends AbsenceRecordsState {}

class AbsenceRecordsErrorState extends AbsenceRecordsState {}
