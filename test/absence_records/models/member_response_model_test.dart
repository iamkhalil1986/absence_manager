import 'package:absence_manager/absence_records/models/member_response_model.dart';

import 'package:flutter_test/flutter_test.dart';

import '../mock_data_provider.dart';

void main() {
  testMemberResponseModel();
}

void testMemberResponseModel() {
  group('MemberResponseModel tests', () {
    test('MemberResponseModel fromJson test', () {
      MemberResponseModel response =
          MemberResponseModel.fromJson(MockDataProvider.memberMap);
      expect(response.props, [
        response.crewId,
        response.id,
        response.image,
        response.name,
        response.userId
      ]);
    });
  });
}
