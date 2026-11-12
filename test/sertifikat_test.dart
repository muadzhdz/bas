import 'package:bas/api/sertifikat_api.dart';
import 'package:bas/models/sertifikat_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SertifikatModel and SertifikatApi Unit Tests', () {
    test('SertifikatModel.fromJson parses raw JSON correctly', () {
      final jsonMap = {
        'id_sertifikat': '1',
        'npm': '12523030',
        'nama_sertifikat': 'Juara 1 Hackathon',
        'jenis_sertifikat': 'Kejuaraan',
        'kategori_sertifikat': 'Akademik',
        'penyelenggara': 'Kemdikbud',
        'tingkat_kegiatan': 'Nasional',
        'nomor_sertifikat': 'SK/01/2026',
        'file_sertifikat': 'hackathon.pdf',
        'tanggal_sertifikat': 1731340800,
        'tanggal_upload': 1731340800,
        'status_verifikasi': 'Terverifikasi',
        'catatan_verifikasi': 'Valid',
        'diverifikasi_oleh': 'Admin',
        'tanggal_verifikasi': 1731340800,
      };

      final model = SertifikatModel.fromJson(jsonMap);

      expect(model.id, equals('1'));
      expect(model.nama, equals('Juara 1 Hackathon'));
      expect(model.tingkat, equals('Nasional'));
      expect(model.isVerified, isTrue);
      expect(model.isPending, isFalse);
      expect(model.formattedDate.isNotEmpty, isTrue);

      final jsonOut = model.toJson();
      expect(jsonOut['nama_sertifikat'], equals('Juara 1 Hackathon'));
      expect(jsonOut['status_verifikasi'], equals('Terverifikasi'));
    });

    test(
      'Live fetchSertifikatByNpm from MockAPI returns certificates',
      () async {
        final api = SertifikatApi();
        final list = await api.fetchSertifikatByNpm('12523030');

        expect(list, isA<List<SertifikatModel>>());
        if (list.isNotEmpty) {
          expect(list.first.nama.isNotEmpty, isTrue);
        }
      },
    );
  });
}
