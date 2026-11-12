import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/mahasiswa_model.dart';
import '../models/user_model.dart';

class SessionService {
  SessionService._();

  static const String _userKey = 'saved_user_session';
  static const String _mahasiswaKey = 'saved_mahasiswa_session';
  static const String _prodiKey = 'saved_prodi_code';

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(user.toJson());
    await prefs.setString(_userKey, jsonString);
  }

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

  static Future<void> saveMahasiswa(MahasiswaModel mahasiswa) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(mahasiswa.toJson());
    await prefs.setString(_mahasiswaKey, jsonString);
    await prefs.setString(_prodiKey, mahasiswa.kodeProdiFormatted);
  }

  static Future<MahasiswaModel?> getMahasiswa() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_mahasiswaKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return MahasiswaModel.fromJson(jsonMap);
    } catch (_) {
      return null;
    }
  }

  static Future<String> getProdiCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prodiKey) ?? '2';
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_mahasiswaKey);
    await prefs.remove(_prodiKey);
  }

  static Future<void> clearUser() async {
    await clearAll();
  }
}
