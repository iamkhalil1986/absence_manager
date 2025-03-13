import 'package:absence_manager/absence_records/models/absence_response_model.dart';
import 'package:absence_manager/core/response_model.dart';

class AbsenceRecordsResponseModel extends ResponseModel {
  final List<AbsenceResponseModel> absenceRecords;

  AbsenceRecordsResponseModel.fromJson(List<dynamic> recordsMap)
      : absenceRecords = recordsMap
            .map((record) => AbsenceResponseModel.fromJson(record))
            .toList();

  @override
  List<Object?> get props => [absenceRecords];
}

// This approach of handling error is very useful when dealing with multiple error scenarios
class AbsenceRecordsServiceErrorResponseModel extends ResponseModel {}

//For Example 409 conflict error statusCode with different messageCode.
//statusCode = 409, messageCode="LIMIT_EXCEEDED"
//statusCode = 409, messageCode="INSUFFICIENT_BALANCE"
//statusCode = 409, messageCode="TRANSACTION_DECLINED"
//In above scenarios we can create error specific response model classes which can be returned from Service class
