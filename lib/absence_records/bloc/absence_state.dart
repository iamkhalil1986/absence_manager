import 'package:equatable/equatable.dart';

class AbsenceState extends Equatable {
  final String name;
  final String type;
  final String startDate;
  final String endDate;
  final String memberNote;
  final String status;
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
