import 'package:equatable/equatable.dart';

class AbsenceResponseModel extends Equatable {
  final int? admitterId;
  final String admitterNote;
  final String? confirmedAt;
  final String createdAt;
  final int crewId;
  final String endDate;
  final int id;
  final String memberNote;
  final String? rejectedAt;
  final String startDate;
  final String type;
  final int userId;

  AbsenceResponseModel.fromJson(Map<String, dynamic> json)
      : admitterId = json['admitterId'],
        admitterNote = json['admitterNote'],
        confirmedAt = json['confirmedAt'],
        createdAt = json['createdAt'],
        crewId = json['crewId'],
        endDate = json['endDate'],
        id = json['id'],
        memberNote = json['memberNote'],
        rejectedAt = json['rejectedAt'],
        startDate = json['startDate'],
        type = json['type'],
        userId = json['userId'];

  @override
  List<Object?> get props => [
        admitterId,
        admitterNote,
        confirmedAt,
        createdAt,
        crewId,
        endDate,
        id,
        memberNote,
        rejectedAt,
        startDate,
        type,
        userId,
      ];
}
