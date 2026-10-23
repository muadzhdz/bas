import 'package:flutter_test/flutter_test.dart';
import 'package:bas/api/nilai_api.dart';
import 'package:bas/models/nilai_model.dart';

void main() {
  group('NilaiModel and NilaiApi Unit Tests', () {
    test('NilaiModel.fromJson correctly parses raw JSON and computes SKS', () {
      final jsonMatkul1 = {
        'id': 162801,
        'kd_matkul': 'GC327',
        'npm': '12523030',
        'uas': '70',
        'uts': '75',
        'quis': '72',
        'tugas': '80',
        'hadir': '100',
        'na_uas': '17.5',
        'na_uts': '15',
        'na_quis': '10.8',
        'na_tugas': '16',
        'na_hadir': '20',
        'hm': 'B+',
        'na': '79.3',
        'am': '3.5',
        'mutu': '10.5',
        'nip': 'LU0512',
        'thn_akademik': '2023/2024',
        'semester': '1',
        'dentry': '2023-09-12 08:15:42',
      };

      final nilai = NilaiModel.fromJson(jsonMatkul1);

      expect(nilai.id, 162801);
      expect(nilai.kdMatkul, 'GC327');
      expect(nilai.npm, '12523030');
      expect(nilai.uas, 70.0);
      expect(nilai.uts, 75.0);
      expect(nilai.quis, 72.0);
      expect(nilai.tugas, 80.0);
      expect(nilai.hadir, 100.0);
      expect(nilai.hm, 'B+');
      expect(nilai.na, 79.3);
      expect(nilai.am, 3.5);
      expect(nilai.mutu, 10.5);
      expect(nilai.sks, 3); // 10.5 / 3.5 = 3 SKS
    });

    test('KhsSummary accurately calculates total SKS and IPS 3.25', () {
      final item1 = NilaiModel(
        id: 162801,
        kdMatkul: 'GC327',
        npm: '12523030',
        uas: 70,
        uts: 75,
        quis: 72,
        tugas: 80,
        hadir: 100,
        naUas: 17.5,
        naUts: 15,
        naQuis: 10.8,
        naTugas: 16,
        naHadir: 20,
        hm: 'B+',
        na: 79.3,
        am: 3.5,
        mutu: 10.5,
        nip: 'LU0512',
        thnAkademik: '2023/2024',
        semester: '1',
        dentry: '2023-09-12 08:15:42',
      );

      final item2 = NilaiModel(
        id: 162869,
        kdMatkul: 'GC302',
        npm: '12523030',
        uas: 68,
        uts: 72,
        quis: 65,
        tugas: 74,
        hadir: 86.67,
        naUas: 17,
        naUts: 14.4,
        naQuis: 9.75,
        naTugas: 14.8,
        naHadir: 17.334,
        hm: 'B',
        na: 73.284,
        am: 3.0,
        mutu: 9.0,
        nip: 'AT2047',
        thnAkademik: '2023/2024',
        semester: '1',
        dentry: '2023-09-12 13:40:08',
      );

      final summary = KhsSummary([item1, item2]);

      expect(summary.totalSks, 6);
      expect(summary.totalMutu, 19.5);
      expect(summary.ips, 3.25);
      expect(summary.ipsFormatted, '3.25');
    });

    test('Live MockAPI Nilai fetch for npm 12523030', () async {
      final api = NilaiApi();
      final summary = await api.fetchKhsSummary('12523030');

      expect(summary.daftarNilai.isNotEmpty, true);
      expect(summary.daftarNilai.length, 2);
      expect(summary.totalSks, 6);
      expect(summary.ipsFormatted, '3.25');
    });
  });
}
