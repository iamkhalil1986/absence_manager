import 'package:absence_manager/absence_records/models/member_response_model.dart';
import 'package:absence_manager/core/response_model.dart';

class MemberRecordsResponseModel extends ResponseModel {
  final List<MemberResponseModel> memberRecords;

  MemberRecordsResponseModel.fromJson(List<dynamic> recordsMap)
      : memberRecords = recordsMap
            .map((record) => MemberResponseModel.fromJson(record))
            .toList();

  @override
  List<Object?> get props => [memberRecords];
}

class MemberRecordsErrorResponseModel extends ResponseModel {}
