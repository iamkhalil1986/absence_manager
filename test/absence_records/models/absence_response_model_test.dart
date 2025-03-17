import 'package:absence_manager/absence_records/models/absence_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_data_provider.dart';

void main() {
  testAbsenceResponseModel();
}

void testAbsenceResponseModel() {
  group('AbsenceResponseModel tests', () {
    test('AbsenceResponseModel fromJson test', () {
      AbsenceResponseModel response =
          AbsenceResponseModel.fromJson(MockDataProvider.absenceRecordMap);
      expect(response.props, [
        response.admitterId,
        response.admitterNote,
        response.confirmedAt,
        response.createdAt,
        response.crewId,
        response.endDate,
        response.id,
        response.memberNote,
        response.rejectedAt,
        response.startDate,
        response.type,
        response.userId,
      ]);
    });
  });
}
