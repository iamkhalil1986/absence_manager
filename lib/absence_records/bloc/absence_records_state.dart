import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:equatable/equatable.dart';

class AbsenceRecordsState extends Equatable {
  final int currentAbsenceRecordsCount;
  final int totalAbsenceRecordsCount;
  final String? dateFilter;
  final AbsenceStatusType? statusFilter;
  final List<AbsenceState> records;

  const AbsenceRecordsState(
      {this.currentAbsenceRecordsCount = 0,
      this.totalAbsenceRecordsCount = 0,
      this.dateFilter,
      this.statusFilter,
      this.records = const []});

  AbsenceRecordsState copyWith(
      {int? currentAbsenceRecordsCount,
      int? totalAbsenceRecordsCount,
      String? dateFilter,
      bool clearDateFilter = false,
      AbsenceStatusType? statusFilter,
      bool clearStatusFilter = false,
      List<AbsenceState>? records}) {
    return AbsenceRecordsState(
        currentAbsenceRecordsCount:
            currentAbsenceRecordsCount ?? this.currentAbsenceRecordsCount,
        totalAbsenceRecordsCount:
            totalAbsenceRecordsCount ?? this.totalAbsenceRecordsCount,
        dateFilter: clearDateFilter ? null : dateFilter ?? this.dateFilter,
        statusFilter:
            clearStatusFilter ? null : statusFilter ?? this.statusFilter,
        records: records ?? this.records);
  }

  @override
  List<Object?> get props => [
        currentAbsenceRecordsCount,
        totalAbsenceRecordsCount,
        dateFilter,
        statusFilter,
        records
      ];
}

class AbsenceRecordsLoadingState extends AbsenceRecordsState {}

class AbsenceRecordsErrorState extends AbsenceRecordsState {}
