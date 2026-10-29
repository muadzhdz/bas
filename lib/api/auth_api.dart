import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class LoginResult {
  final bool isSuccess;
  final String message;
  final UserModel? user;

  const LoginResult({
    required this.isSuccess,
    required this.message,
    this.user,
  });

  factory LoginResult.success({required String message, required UserModel user}) {
    return LoginResult(isSuccess: true, message: message, user: user);
  }

  factory LoginResult.failure(String message) {
    return LoginResult(isSuccess: false, message: message, user: null);
  }
}

class AuthApi {
  static const String endpoint = 'https://6adab9277512f497b30020ef.mockapi.io/user';

  // Mengubah plain text password menjadi SHA-1 hash hex string
  String hashSha1(String input) {
    final bytes = utf8.encode(input);
    return sha1.convert(bytes).toString();
  }

  // Mengambil seluruh data user dari MockAPI (fallback / utility)
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http
          .get(Uri.parse(endpoint))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((jsonItem) => UserModel.fromJson(jsonItem)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Mengambil 1 user pertama
  Future<UserModel?> fetchFirstUser() async {
    final users = await fetchUsers();
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // Proses verifikasi login langsung menggunakan query parameter:
  // https://6adab9277512f497b30020ef.mockapi.io/user?userid={NPM}&pass_sha1={HASH}
  Future<LoginResult> verifyLogin({
    required String npm,
    required String rawPassword,
  }) async {
    final cleanNpm = npm.trim();
    if (cleanNpm.isEmpty) {
      return LoginResult.failure('NPM / User ID tidak boleh kosong.');
    }
    if (rawPassword.isEmpty) {
      return LoginResult.failure('Password tidak boleh kosong.');
    }

    final passwordSha1 = hashSha1(rawPassword).toLowerCase();
    final queryUrl = '$endpoint?userid=$cleanNpm&pass_sha1=$passwordSha1';

    try {
      final response = await http
          .get(Uri.parse(queryUrl))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is List && decoded.isNotEmpty) {
          final user = UserModel.fromJson(decoded.first);

          // 1. Verifikasi roleid: wajib bernilai 14 (Mahasiswa)
          if (user.roleid != 14) {
            return LoginResult.failure('Role ID tidak diizinkan (Role saat ini: ${user.roleid}, harus 14).');
          }

          // 2. Verifikasi status akun: jika 1 aktif, jika 0 disable
          if (user.status == 0 || user.aktif == 0) {
            return LoginResult.failure('Status akun nonaktif (status: ${user.status}, aktif: ${user.aktif}). Hubungi admin.');
          }

          // 3. Verifikasi sukses
          return LoginResult.success(
            message: 'Selamat datang ${user.nama}',
            user: user,
          );
        }
      }

      // Jika response 404 atau list kosong
      return LoginResult.failure('NPM atau Password salah.');
    } catch (e) {
      return LoginResult.failure('Gagal menghubungi server MockAPI.');
    }
  }
}
