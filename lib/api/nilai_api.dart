import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/nilai_model.dart';

class NilaiApi {
  static const String baseUrl =
      'https://6adab9277512f497b30020ef.mockapi.io/nilai';

  Future<List<NilaiModel>> fetchNilaiByNpm(String npm) async {
    final cleanNpm = npm.trim();
    final url = cleanNpm.isNotEmpty ? '$baseUrl?npm=$cleanNpm' : baseUrl;

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return data.map((item) => NilaiModel.fromJson(item)).toList();
        }
      }

      if (cleanNpm != '12523030') {
        final fallbackResponse = await http
            .get(Uri.parse('$baseUrl?npm=12523030'))
            .timeout(const Duration(seconds: 15));

        if (fallbackResponse.statusCode == 200) {
          final dynamic fallbackData = json.decode(fallbackResponse.body);
          if (fallbackData is List && fallbackData.isNotEmpty) {
            return fallbackData
                .map((item) => NilaiModel.fromJson(item))
                .toList();
          }
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  Future<KhsSummary> fetchKhsSummary(String npm) async {
    final list = await fetchNilaiByNpm(npm);
    return KhsSummary(list);
  }
}
