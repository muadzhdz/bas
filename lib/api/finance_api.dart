import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/finance_model.dart';

class FinanceApi {
  static const String baseUrl =
      'https://6adab9277512f497b30020ef.mockapi.io/fin_mhs_payment';

  final http.Client _client;

  FinanceApi({http.Client? client}) : _client = client ?? http.Client();

  Future<List<FinanceModel>> fetchPaymentsByNpm(String npm) async {
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
                (item) => FinanceModel.fromJson(item as Map<String, dynamic>),
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
                  (item) => FinanceModel.fromJson(item as Map<String, dynamic>),
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
}
