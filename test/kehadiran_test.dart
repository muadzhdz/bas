import 'package:bas/api/kehadiran_api.dart';
import 'package:bas/models/kehadiran_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KehadiranModel and KehadiranApi Unit Tests', () {
    test('KehadiranModel.fromJson parses raw JSON correctly', () {
      final jsonMap = {
        'id': 1548149,
        'userid': '12523030',
        'jam_login': '09:00:00',
        'kd_matkul': 'GC327',
        'kd_kelas': 'A',
        'tanggal': '2023-09-11',
        'keterangan': '1',
        'session': '1',
        'thn_akademik': '2023/2024',
        'semester': '1',
        'bhadir_check': '0',
      };

      final model = KehadiranModel.fromJson(jsonMap);

      expect(model.id, equals(1548149));
      expect(model.userId, equals('12523030'));
      expect(model.kodeMatkul, equals('GC327'));
      expect(model.kodeKelas, equals('A'));
      expect(model.jamLogin, equals('09:00:00'));
      expect(model.isHadir, isTrue);

      final jsonOut = model.toJson();
      expect(jsonOut['kd_matkul'], equals('GC327'));
      expect(jsonOut['userid'], equals('12523030'));
    });

    test('Live fetchKehadiranByUserId from MockAPI returns records', () async {
      final api = KehadiranApi();
      final list = await api.fetchKehadiranByUserId('12523030');

      expect(list, isA<List<KehadiranModel>>());
      if (list.isNotEmpty) {
        expect(list.first.kodeMatkul.isNotEmpty, isTrue);
      }
    });
  });
}
