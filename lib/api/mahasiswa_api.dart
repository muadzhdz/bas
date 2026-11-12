import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/mahasiswa_model.dart';

class MahasiswaApi {
  static const String baseUrl =
      'https://6aed363dfc3b911e6fd60ab2.mockapi.io/mahasiswa';

  Future<MahasiswaModel?> fetchMahasiswaByNpm(String npm) async {
    final cleanNpm = npm.trim();
    final url = cleanNpm.isNotEmpty ? '$baseUrl?npm=$cleanNpm' : baseUrl;

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return MahasiswaModel.fromJson(data.first);
        }
      }

      if (cleanNpm != '12523030') {
        final fallbackResponse = await http
            .get(Uri.parse('$baseUrl?npm=12523030'))
            .timeout(const Duration(seconds: 15));

        if (fallbackResponse.statusCode == 200) {
          final dynamic fallbackData = json.decode(fallbackResponse.body);
          if (fallbackData is List && fallbackData.isNotEmpty) {
            return MahasiswaModel.fromJson(fallbackData.first);
          }
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
