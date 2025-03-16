import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:equatable/equatable.dart';

class AbsenceRecordsFilterModel extends Equatable {
  final DateTime? selectedDate;
  final AbsenceRequestType? selectedRequestType;

  const AbsenceRecordsFilterModel(
      {this.selectedDate, this.selectedRequestType});

  @override
  List<Object?> get props => [selectedDate, selectedRequestType];
}
