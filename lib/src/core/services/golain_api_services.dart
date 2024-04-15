import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GolainApiService {
  late String _bearerToken;
  String orgId = "4f68fbb2-b78c-494a-bd76-9753fb6ec390";
  late String _baseUrl;

  late Dio _dio;

  GolainApiService() {
    _bearerToken = dotenv.env["GOLAIN_API_BEARER_TOKEN"]!;
    _baseUrl = dotenv.env["GOLAIN_API_BASE_URL"]!;
    _dio = Dio();
  }

  Future post({required String endpoint, required Map body}) async {
    final headers = {
      'Authorization': 'Bearer $_bearerToken',
      'ORG-ID': orgId,
    };

    log("Method: GET");
    log("Request URL: ${_baseUrl + endpoint}");

    try {
      final response = _dio.post(_baseUrl + endpoint,
          options: Options(
            headers: headers,
          ),
          data: body);
      return response;
    } catch (e) {
      log("error : $e");
      return null;
    }
  }

  Future get({required String endpoint}) async {
    final headers = {
      'Authorization': 'Bearer $_bearerToken',
      'ORG-ID': orgId,
    };

    log("Method: GET");
    log("Request URL: ${_baseUrl + endpoint}");
    // log(headers.toString());

    try {
      final response = await _dio.get(
        _baseUrl + endpoint,
        options: Options(
          headers: headers,
        ),
      );
      return response;
    } catch (e) {
      log("error : $e");
      return null;
    }
  }
}
