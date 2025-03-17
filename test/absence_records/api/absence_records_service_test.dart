import 'package:absence_manager/absence_records/api/absence_records_service.dart';
import 'package:absence_manager/absence_records/models/absence_records_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../mock_data_provider.dart';

void main() {
  testAbsenceRecordsService();
}

void testAbsenceRecordsService() {
  group('AbsenceRecordsService tests', () {
    setUpAll(() {
      registerFallbackValue(Uri.http('', ''));
    });

    test('AbsenceRecordsService success test', () async {
      final service = AbsenceRecordsService(
          client: MockHttpClient.withSuccess(
              response: MockDataProvider.absenceRecordsResponseString));
      final response = await service.executeService();
      expect(response is AbsenceRecordsResponseModel, true);
    });

    test('AbsenceRecordsService failure test', () async {
      final service =
          AbsenceRecordsService(client: MockHttpClient.withFailure());
      final response = await service.executeService();
      expect(response is AbsenceRecordsErrorResponseModel, true);
    });
  });
}
