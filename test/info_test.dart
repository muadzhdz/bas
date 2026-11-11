import 'package:bas/api/info_api.dart';
import 'package:bas/models/info_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InfoModel and InfoApi Unit Tests', () {
    test('InfoModel.fromJson parses raw JSON correctly', () {
      final jsonMap = {
        'id_informasi': '42',
        'kd_progstudi': 97,
        'judul_informasi': 'Pemberitahuan KRS',
        'isi_informasi': 'Pengisian KRS dibuka sampai akhir pekan.',
        'tgl_posting_informasi': '2026-11-05',
        'informasi_dari': 'BAAK',
      };

      final model = InfoModel.fromJson(jsonMap);

      expect(model.id, equals('42'));
      expect(model.kodeProdi, equals(97));
      expect(model.judul, equals('Pemberitahuan KRS'));
      expect(model.isi, equals('Pengisian KRS dibuka sampai akhir pekan.'));
      expect(model.tanggalPosting, equals('2026-11-05'));
      expect(model.sumber, equals('BAAK'));

      final jsonOut = model.toJson();
      expect(jsonOut['id_informasi'], equals('42'));
      expect(jsonOut['kd_progstudi'], equals(97));
    });

    test('Live fetchInfo from MockAPI returns list of info', () async {
      final api = InfoApi();
      final list = await api.fetchInfo();

      expect(list, isA<List<InfoModel>>());
      if (list.isNotEmpty) {
        expect(list.first.judul.isNotEmpty, isTrue);
      }
    });
  });
}
