import 'package:absence_manager/absence_records/api/member_records_service.dart';
import 'package:absence_manager/absence_records/models/member_records_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../mock_data_provider.dart';

void main() {
  testMemberRecordsService();
}

void testMemberRecordsService() {
  group('MemberRecordsService tests', () {
    setUpAll(() {
      registerFallbackValue(Uri.http('', ''));
    });

    test('MemberRecordsService success test', () async {
      final service = MemberRecordsService(
          client: MockHttpClient.withSuccess(
              response: MockDataProvider.membersJsonResponseString));
      final response = await service.executeService();
      expect(response is MemberRecordsResponseModel, true);
    });

    test('MemberRecordsService failure test', () async {
      final service =
          MemberRecordsService(client: MockHttpClient.withFailure());
      final response = await service.executeService();
      expect(response is MemberRecordsErrorResponseModel, true);
    });
  });
}
