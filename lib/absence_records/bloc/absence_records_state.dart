import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:equatable/equatable.dart';

class AbsenceRecordsState extends Equatable {
  final int visibleRecordsCount;
  final int allRecordsCount;
  final String? dateFilter;
  final AbsenceStatusType? statusFilter;
  final List<AbsenceState> records;

  const AbsenceRecordsState(
      {this.visibleRecordsCount = 0,
      this.allRecordsCount = 0,
      this.dateFilter,
      this.statusFilter,
      this.records = const []});

  AbsenceRecordsState copyWith(
      {int? visibleRecordsCount,
      int? allRecordsCount,
      String? dateFilter,
      AbsenceStatusType? statusFilter,
      List<AbsenceState>? records}) {
    return AbsenceRecordsState(
        visibleRecordsCount: visibleRecordsCount ?? this.visibleRecordsCount,
        allRecordsCount: allRecordsCount ?? this.allRecordsCount,
        dateFilter: dateFilter ?? this.dateFilter,
        statusFilter: statusFilter ?? this.statusFilter,
        records: records ?? this.records);
  }

  @override
  List<Object?> get props =>
      [visibleRecordsCount, allRecordsCount, dateFilter, statusFilter, records];
}

class AbsenceRecordsLoadingState extends AbsenceRecordsState {}

class AbsenceRecordsErrorState extends AbsenceRecordsState {}
