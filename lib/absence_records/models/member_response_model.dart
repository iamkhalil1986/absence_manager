import 'package:equatable/equatable.dart';

class MemberResponseModel extends Equatable {
  final int crewId;
  final int id;
  final String image;
  final String name;
  final int userId;

  MemberResponseModel.fromJson(Map<String, dynamic> json)
      : crewId = json['crewId'],
        id = json['id'],
        image = json['image'],
        name = json['name'],
        userId = json['userId'];

  @override
  List<Object?> get props => [crewId, id, image, name, userId];
}
