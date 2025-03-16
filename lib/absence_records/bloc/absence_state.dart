import 'package:absence_manager/absence_records/absence_records_enums.dart';
import 'package:equatable/equatable.dart';

class AbsenceState extends Equatable {
  final String name;
  final AbsenceRequestType type;
  final DateTime startDate;
  final DateTime endDate;
  final String memberNote;
  final AbsenceStatusType status;
  final String admitterNote;

  const AbsenceState(
      {required this.name,
      required this.type,
      required this.startDate,
      required this.endDate,
      required this.memberNote,
      required this.status,
      required this.admitterNote});

  @override
  List<Object?> get props =>
      [name, type, startDate, endDate, memberNote, status, admitterNote];
}
