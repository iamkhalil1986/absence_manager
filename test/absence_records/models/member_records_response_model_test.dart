import 'package:absence_manager/absence_records/models/member_records_response_model.dart';

import 'package:flutter_test/flutter_test.dart';

import '../mock_data_provider.dart';

void main() {
  testMemberRecordsResponseModel();
}

void testMemberRecordsResponseModel() {
  group('MemberRecordsResponseModel tests', () {
    test('MemberRecordsResponseModel fromJson test', () {
      MemberRecordsResponseModel response =
          MemberRecordsResponseModel.fromJson(MockDataProvider.membersMapList);
      expect(response.props, [response.members]);
    });
  });
}
