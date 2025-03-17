import 'package:absence_manager/absence_records/models/absence_records_response_model.dart';
import 'package:absence_manager/core/app_configuration.dart';
import 'package:absence_manager/core/response_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AbsenceRecordsService {
  late final http.Client _client;

  AbsenceRecordsService({http.Client? client})
      : _client = client ?? http.Client();

  Future<ResponseModel> executeService() async {
    var url = Uri.http(AppConfiguration.baseURL, '/absences');
    var response = await _client.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return Future.value(
          AbsenceRecordsResponseModel.fromJson(jsonResponse['payload']));
    } else {
      return Future.value(AbsenceRecordsErrorResponseModel());
    }
  }
}
