enum AbsenceRequestType {
  sickness(type: "sickness"),
  vacation(type: "vacation");

  const AbsenceRequestType({required this.type});
  final String type;
}

enum AbsenceStatusType { requested, confirmed, rejected }
