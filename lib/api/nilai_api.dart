import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/nilai_model.dart';

class NilaiApi {
  static const String baseUrl =
      'https://6adab9277512f497b30020ef.mockapi.io/nilai';

  // Mengambil daftar nilai mahasiswa berdasarkan NPM
  Future<List<NilaiModel>> fetchNilaiByNpm(String npm) async {
    final cleanNpm = npm.trim();
    final url = cleanNpm.isNotEmpty ? '$baseUrl?npm=$cleanNpm' : baseUrl;

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => NilaiModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Mengambil ringkasan KHS (termasuk total SKS dan IPS)
  Future<KhsSummary> fetchKhsSummary(String npm) async {
    final list = await fetchNilaiByNpm(npm);
    return KhsSummary(list);
  }
}
