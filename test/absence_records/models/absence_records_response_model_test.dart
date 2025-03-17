import 'package:absence_manager/absence_records/models/absence_records_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_data_provider.dart';

void main() {
  testAbsenceRecordsResponseModel();
}

void testAbsenceRecordsResponseModel() {
  group('AbsenceRecordsResponseModel tests', () {
    test('AbsenceRecordsResponseModel fromJson test', () {
      AbsenceRecordsResponseModel response =
          AbsenceRecordsResponseModel.fromJson(
              MockDataProvider.absenceRecordsMapList);
      expect(response.props, [response.records]);
    });
  });
}
