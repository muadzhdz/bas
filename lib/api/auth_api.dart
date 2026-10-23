import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  Future<Map<String, dynamic>?> fetchRandomUser() async {
    try {
      final response = await http.get(Uri.parse('https://randomuser.me/api/'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'][0]; // ambil 1 user
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
