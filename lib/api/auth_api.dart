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

  // Mengambil seluruh data user dari MockAPI
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((jsonItem) => UserModel.fromJson(jsonItem)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // Mengambil 1 user pertama (untuk preview / auto-fill testing)
  Future<UserModel?> fetchFirstUser() async {
    final users = await fetchUsers();
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  // Mengubah plain text password menjadi SHA-1 hash hex string
  String hashSha1(String input) {
    final bytes = utf8.encode(input);
    return sha1.convert(bytes).toString();
  }

  // Proses verifikasi login sesuai kriteria dosen
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

    final users = await fetchUsers();
    if (users.isEmpty) {
      return LoginResult.failure('Gagal menghubungi server MockAPI atau data kosong.');
    }

    // 1. Cari user berdasarkan userid (NPM)
    final userMatch = users.where((u) => u.userid.toString() == cleanNpm);
    if (userMatch.isEmpty) {
      return LoginResult.failure('NPM / User ID "$cleanNpm" tidak ditemukan.');
    }

    final user = userMatch.first;

    // 2. Hash password input dengan SHA-1 dan bandingkan dengan pass_sha1 / pass
    final passwordSha1 = hashSha1(rawPassword).toLowerCase();
    final isPasswordValid = user.passSha1.toLowerCase() == passwordSha1 ||
        user.pass.toLowerCase() == passwordSha1 ||
        user.pass == rawPassword ||
        user.passSha1 == rawPassword;

    if (!isPasswordValid) {
      return LoginResult.failure('Password salah.');
    }

    // 3. Verifikasi roleid: wajib bernilai 14
    if (user.roleid != 14) {
      return LoginResult.failure('Role ID tidak diizinkan (Role saat ini: ${user.roleid}, harus 14).');
    }

    // 4. Verifikasi status akun: jika 1 aktif, jika 0 disable
    if (user.status == 0 || user.aktif == 0) {
      return LoginResult.failure('Status akun nonaktif (status: ${user.status}, aktif: ${user.aktif}). Hubungi admin.');
    }

    // 5. Verifikasi sukses: "selamat datang user(ngambil dari nama)"
    return LoginResult.success(
      message: 'Selamat datang ${user.nama}',
      user: user,
    );
  }
}
