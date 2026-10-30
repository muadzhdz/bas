import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class SessionService {
  SessionService._();

  static const String _userKey = 'saved_user_session';

  /// Menyimpan sesi user ke penyimpanan lokal perangkat
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, jsonString);
  }

  /// Mengambil data user yang tersimpan di perangkat jika ada
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_userKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return UserModel.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  /// Menghapus sesi user saat logout
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
