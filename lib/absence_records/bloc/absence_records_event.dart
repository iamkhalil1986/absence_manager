import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:equatable/equatable.dart';

class AbsenceRecordsEvent extends Equatable {
  const AbsenceRecordsEvent();
  @override
  List<Object?> get props => [];
}

class AbsenceRecordsWithFilterEvent extends AbsenceRecordsEvent {
  final String? filterDate;
  final AbsenceStatusType? filterStatus;

  const AbsenceRecordsWithFilterEvent({this.filterDate, this.filterStatus});

  @override
  List<Object?> get props => [filterDate, filterStatus];
}
