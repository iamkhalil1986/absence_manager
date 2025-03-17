import 'absence_records/api/absence_records_service_test.dart';
import 'absence_records/api/member_records_service_test.dart';
import 'absence_records/bloc/absence_records_bloc_test.dart';
import 'absence_records/bloc/absence_records_event_test.dart';
import 'absence_records/bloc/absence_records_state_test.dart';
import 'absence_records/bloc/absence_state_test.dart';
import 'absence_records/models/absence_records_response_model_test.dart';
import 'absence_records/models/absence_response_model_test.dart';
import 'absence_records/models/member_records_response_model_test.dart';
import 'absence_records/models/member_response_model_test.dart';

void main() {
  //bloc tests
  testAbsenceRecordsBloc();
  testAbsenceRecordsEvent();
  testAbsenceRecordsState();
  testAbsenceState();
  //api tests
  testAbsenceRecordsService();
  testMemberRecordsService();
  //models tests
  testAbsenceRecordsResponseModel();
  testAbsenceResponseModel();
  testMemberRecordsResponseModel();
  testMemberResponseModel();
}
