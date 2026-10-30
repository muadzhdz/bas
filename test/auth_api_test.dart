import 'package:flutter_test/flutter_test.dart';
import 'package:bas/api/auth_api.dart';
import 'package:bas/models/user_model.dart';

void main() {
  group('AuthApi and UserModel Unit Tests', () {
    final authApi = AuthApi();

    test('SHA-1 hash matches mockapi hash for password "12523030"', () {
      final hashed = authApi.hashSha1('12523030');
      expect(hashed.toLowerCase(), '5bd2b3ecbed00f8cd09c073ff02be2d14ed28ecf');
    });

    test('UserModel.fromJson parses raw JSON correctly', () {
      final json = {
        'id_users': '1',
        'userid': '12523030',
        'nama': 'Sofi Arianti',
        'login_name': 'sofi',
        'pass': 'sofi',
        'pass_sha1': '5bd2b3ecbed00f8cd09c073ff02be2d14ed28ecf',
        'roleid': 14,
        'status': 1,
        'aktif': 1,
        'babsen': 1,
        'bperwalian': 1,
        'bujian': 1,
      };

      final user = UserModel.fromJson(json);

      expect(user.userid, 12523030);
      expect(user.nama, 'Sofi Arianti');
      expect(user.isRoleMahasiswa, true);
      expect(user.isStatusAktif, true);
      expect(user.isAbsenAktif, true);
      expect(user.isKrsAktif, true);
      expect(user.isUjianAktif, true);
    });

    test(
      'UserModel handles disabled flags (status: 0, babsen: 0, bperwalian: 0)',
      () {
        final json = {
          'id_users': '2',
          'userid': 12523031,
          'nama': 'Nonaktif User',
          'login_name': 'nonaktif',
          'pass': 'pass',
          'pass_sha1': 'abc',
          'roleid': 10,
          'status': 0,
          'aktif': 0,
          'babsen': 0,
          'bperwalian': 0,
          'bujian': 0,
        };

        final user = UserModel.fromJson(json);

        expect(user.isRoleMahasiswa, false);
        expect(user.isStatusAktif, false);
        expect(user.isAbsenAktif, false);
        expect(user.isKrsAktif, false);
      },
    );

    test('Live MockAPI fetch and verify login for user 12523030', () async {
      final result = await authApi.verifyLogin(
        npm: '12523030',
        rawPassword: '12523030',
      );

      expect(result.isSuccess, true);
      expect(result.message, startsWith('Selamat datang Sofi'));
      expect(result.user, isNotNull);
      expect(result.user!.nama, startsWith('Sofi'));
      expect(result.user!.roleid, 14);
      expect(result.user!.isStatusAktif, true);
      expect(result.user!.isAbsenAktif, true);
      expect(result.user!.isKrsAktif, true);
    });

    test('Wrong password returns failure', () async {
      final result = await authApi.verifyLogin(
        npm: '12523030',
        rawPassword: 'password_yang_salah',
      );

      expect(result.isSuccess, false);
      expect(result.message, 'NPM atau Password salah.');
      expect(result.user, isNull);
    });

    test('Non-existent NPM returns failure', () async {
      final result = await authApi.verifyLogin(
        npm: '999999999',
        rawPassword: '123',
      );

      expect(result.isSuccess, false);
      expect(result.message, 'NPM atau Password salah.');
    });
  });
}
