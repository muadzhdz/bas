import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/info_model.dart';

class InfoApi {
  static const String baseUrl =
      'https://6adab9277512f497b30020ef.mockapi.io/informasi';

  final http.Client _client;

  InfoApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<InfoModel>> fetchInfo() async {
    try {
      final response = await _client
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List) {
          return data
              .map((item) => InfoModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
