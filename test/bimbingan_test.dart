import 'package:bas/api/bimbingan_api.dart';
import 'package:bas/models/bimbingan_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BimbinganModel and BimbinganApi Unit Tests', () {
    test('BimbinganModel.fromJson parses raw JSON correctly', () {
      final jsonMap = {
        'thn_akademik': '2026/2027',
        'npm': '12523030',
        'tgl_mulai': '2026-09-01',
        'tgl_selesai': '2027-02-28',
        'judul': 'Sistem Informasi Akademik',
        'topik': 'Sistem Informasi',
        'permasalahan': 'Pengelolaan manual',
        'nip': '198503152010011001',
        'proposal': 1,
        'sk_proposal': 'SK/PROPOSAL/001/2026',
        'status_proposal': 1,
        'tugas_akhir': 'Sistem Informasi Akademik',
        'sk_tugas_akhir': 'SK/TA/001/2026',
        'status_tugas_akhir': 0,
        'status_data': 1,
      };

      final model = BimbinganModel.fromJson(jsonMap);

      expect(model.npm, equals('12523030'));
      expect(model.judul, equals('Sistem Informasi Akademik'));
      expect(model.topik, equals('Sistem Informasi'));
      expect(model.nipDosen, equals('198503152010011001'));
      expect(model.isProposalApproved, isTrue);
      expect(model.isTugasAkhirCompleted, isFalse);

      final jsonOut = model.toJson();
      expect(jsonOut['sk_proposal'], equals('SK/PROPOSAL/001/2026'));
      expect(jsonOut['status_proposal'], equals(1));
    });

    test(
      'Live fetchBimbinganByNpm from MockAPI returns bimbingan data',
      () async {
        final api = BimbinganApi();
        final data = await api.fetchBimbinganByNpm('12523030');

        expect(data, isNotNull);
        expect(data!.judul.isNotEmpty, isTrue);
        expect(data.nipDosen.isNotEmpty, isTrue);
      },
    );
  });
}
