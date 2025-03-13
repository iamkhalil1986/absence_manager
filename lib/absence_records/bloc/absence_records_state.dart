import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:absence_manager/absence_records/bloc/absence_state.dart';
import 'package:equatable/equatable.dart';

class AbsenceRecordsState extends Equatable {
  final int visibleRecordsCount;
  final int allRecordsCount;
  final String? dateFilter;
  final AbsenceStatusType? statusFilter;
  final List<AbsenceState> records;
  final bool hasError;

  const AbsenceRecordsState(
      {this.visibleRecordsCount = 0,
      this.allRecordsCount = 0,
      this.dateFilter,
      this.statusFilter,
      this.records = const [],
      this.hasError = false});

  @override
  List<Object?> get props => [
        visibleRecordsCount,
        allRecordsCount,
        dateFilter,
        statusFilter,
        records,
        hasError
      ];
}
