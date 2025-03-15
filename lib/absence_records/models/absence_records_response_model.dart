import 'package:absence_manager/absence_records/models/absence_response_model.dart';
import 'package:absence_manager/core/response_model.dart';

class AbsenceRecordsResponseModel extends ResponseModel {
  final List<AbsenceResponseModel> records;

  AbsenceRecordsResponseModel.fromJson(List<dynamic> recordsMap)
      : records = recordsMap
            .map((record) => AbsenceResponseModel.fromJson(record))
            .toList();

  @override
  List<Object?> get props => [records];
}

// This approach of handling error is very useful when dealing with multiple error scenarios
class AbsenceRecordsErrorResponseModel extends ResponseModel {}

//For Example 409 conflict error statusCode with different messageCode.
//statusCode = 409, messageCode="LIMIT_EXCEEDED"
//statusCode = 409, messageCode="INSUFFICIENT_BALANCE"
//statusCode = 409, messageCode="TRANSACTION_DECLINED"
//In above scenarios we can create error specific response model classes which can be returned from Service class
