import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/kehadiran_model.dart';

class KehadiranApi {
  static const String baseUrl =
      'https://6adab9277512f497b30020ef.mockapi.io/kehadiran';

  final http.Client _client;

  KehadiranApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<KehadiranModel>> fetchKehadiranByUserId(String userId) async {
    final cleanId = userId.trim();
    final url = cleanId.isNotEmpty ? '$baseUrl?userid=$cleanId' : baseUrl;

    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data
              .map(
                (item) => KehadiranModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
      }

      if (cleanId != '12523030') {
        final fallbackResponse = await _client
            .get(Uri.parse('$baseUrl?userid=12523030'))
            .timeout(const Duration(seconds: 15));

        if (fallbackResponse.statusCode == 200) {
          final dynamic fallbackData = json.decode(fallbackResponse.body);
          if (fallbackData is List && fallbackData.isNotEmpty) {
            return fallbackData
                .map(
                  (item) =>
                      KehadiranModel.fromJson(item as Map<String, dynamic>),
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

  Future<bool> submitKehadiran(KehadiranModel item) async {
    try {
      final payload = item.toJson();
      payload.remove('id');

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
