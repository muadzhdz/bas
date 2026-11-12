import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/sertifikat_model.dart';

class SertifikatApi {
  static const String baseUrl =
      'https://6adab9277512f497b30020ef.mockapi.io/sertifikat';

  final http.Client _client;

  SertifikatApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<SertifikatModel>> fetchSertifikatByNpm(String npm) async {
    final cleanNpm = npm.trim();
    final url = cleanNpm.isNotEmpty ? '$baseUrl?npm=$cleanNpm' : baseUrl;

    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data
              .map(
                (item) =>
                    SertifikatModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
      }

      if (cleanNpm != '12523030') {
        final fallbackResponse = await _client
            .get(Uri.parse('$baseUrl?npm=12523030'))
            .timeout(const Duration(seconds: 15));

        if (fallbackResponse.statusCode == 200) {
          final dynamic fallbackData = json.decode(fallbackResponse.body);
          if (fallbackData is List && fallbackData.isNotEmpty) {
            return fallbackData
                .map(
                  (item) =>
                      SertifikatModel.fromJson(item as Map<String, dynamic>),
                )
                .toList();
          }
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  Future<bool> createSertifikat(SertifikatModel sertifikat) async {
    try {
      final payload = sertifikat.toJson();
      payload.remove('id_sertifikat');

      final response = await _client
          .post(
            Uri.parse(baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(payload),
          )
          .timeout(const Duration(seconds: 15));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}
