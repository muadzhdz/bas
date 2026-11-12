import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/krs_model.dart';

class KrsApi {
  static const String baseUrl =
      'https://6aed363dfc3b911e6fd60ab2.mockapi.io/krs';

  Future<List<KrsModel>> fetchKrsByNpm(String npm) async {
    final cleanNpm = npm.trim();
    final url = cleanNpm.isNotEmpty ? '$baseUrl?npm=$cleanNpm' : baseUrl;

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is List && decoded.isNotEmpty) {
          return decoded.map((item) => KrsModel.fromJson(item)).toList();
        }
      }

      if (cleanNpm != '12523030') {
        final fallbackResponse = await http
            .get(Uri.parse('$baseUrl?npm=12523030'))
            .timeout(const Duration(seconds: 15));

        if (fallbackResponse.statusCode == 200) {
          final dynamic fallbackDecoded = json.decode(fallbackResponse.body);
          if (fallbackDecoded is List && fallbackDecoded.isNotEmpty) {
            return fallbackDecoded
                .map((item) => KrsModel.fromJson(item))
                .toList();
          }
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  Future<KrsModel?> submitKrs({
    required String npm,
    required String kdMatkul,
    required String kdKelas,
    required String thnAkademik,
    required String semester,
    required String semesterNow,
  }) async {
    try {
      final payload = {
        'npm': npm.trim(),
        'kd_matkul': kdMatkul.trim(),
        'kd_kelas': kdKelas.trim(),
        'thn_akademik': thnAkademik.trim(),
        'semester': semester.trim(),
        'thn_akademik_now': thnAkademik.trim(),
        'semester_now': semesterNow.trim(),
        'status': 0,
      };

      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(payload),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is Map<String, dynamic>) {
          return KrsModel.fromJson(decoded);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> deleteKrs(String id) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/$id'))
          .timeout(const Duration(seconds: 15));
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (_) {
      return false;
    }
  }
}
