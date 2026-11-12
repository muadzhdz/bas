import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bas/models/mahasiswa_model.dart';
import 'package:bas/services/session_service.dart';
import 'package:bas/widgets/gender_avatar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MahasiswaModel Tests', () {
    test('MahasiswaModel.fromJson correctly parses female student', () {
      final json = {
        'npm': '12523030',
        'nama': 'Sofi Arianti ',
        'tempat_lahir': 'Bogor',
        'tgl_lahir': '2004-05-12',
        'agama': 'Islam',
        'kelamin': '0',
        'perkawinan': 'Belum Menikah',
        'warga_negara': 'Indonesia',
        'alamat': 'Jl. Boash Raya No. 12',
        'cprovinsi': 'Jawa Barat',
        'kodepos': '16610',
        'tlp_rumah': '0251888999',
        'handphone': '081234567890',
        'email': 'sofi@boash.ac.id',
        'asal_sekolah': 'SMK Boash',
        'kd_progstudi': '2',
        'kd_jenjang': '5',
        'kd_kelas': 'A',
        'tahun_masuk': '2023/2024',
        'status': '1',
        'foto': '',
        'google_id': '',
      };

      final mhs = MahasiswaModel.fromJson(json);

      expect(mhs.npm, '12523030');
      expect(mhs.nama, 'Sofi Arianti');
      expect(mhs.isPerempuan, isTrue);
      expect(mhs.jenisKelaminFormatted, 'Perempuan');
      expect(mhs.namaProdi, 'Teknologi Rekayasa Multimedia');
      expect(mhs.jenjangFormatted, 'D4 / Sarjana Terapan');
      expect(mhs.isAktif, isTrue);
      expect(mhs.statusMahasiswaLabel, 'Aktif');
      expect(mhs.ttlFormatted, 'Bogor, 2004-05-12');
      expect(
        mhs.alamatLengkap,
        'Jl. Boash Raya No. 12, Jawa Barat, Kode Pos 16610',
      );
    });

    test('MahasiswaModel.fromJson correctly parses male student', () {
      final json = {
        'npm': '24903460014',
        'nama': "Mu'adz Hudzaifah",
        'tempat_lahir': 'Jakarta',
        'tgl_lahir': '2003-08-20',
        'agama': 'Islam',
        'kelamin': '1',
        'perkawinan': 'Belum Menikah',
        'warga_negara': 'Indonesia',
        'alamat': 'Jl. Merdeka No. 45',
        'cprovinsi': 'DKI Jakarta',
        'kodepos': '10110',
        'tlp_rumah': '',
        'handphone': '085694718914',
        'email': 'muadz@boash.ac.id',
        'asal_sekolah': 'SMA Negeri 1',
        'kd_progstudi': '1',
        'kd_jenjang': '6',
        'kd_kelas': 'B',
        'tahun_masuk': '2024/2025',
        'status': '1',
        'foto': '',
        'google_id': '',
      };

      final mhs = MahasiswaModel.fromJson(json);

      expect(mhs.npm, '24903460014');
      expect(mhs.isPerempuan, isFalse);
      expect(mhs.jenisKelaminFormatted, 'Laki-laki');
      expect(mhs.namaProdi, 'Teknik Informatika');
      expect(mhs.jenjangFormatted, 'S1 / Sarjana');
    });
  });

  group('SessionService Mahasiswa Persistence', () {
    test('saveMahasiswa and getMahasiswa work seamlessly', () async {
      SharedPreferences.setMockInitialValues({});

      final initial = MahasiswaModel(
        npm: '12523030',
        nama: 'Sofi Arianti',
        tempatLahir: 'Bogor',
        tglLahir: '2004-05-12',
        agama: 'Islam',
        kelamin: '0',
        perkawinan: 'Belum Menikah',
        wargaNegara: 'Indonesia',
        alamat: 'Jl. Boash',
        cprovinsi: 'Jawa Barat',
        kodepos: '16610',
        tlpRumah: '',
        handphone: '081234567890',
        email: 'sofi@boash.ac.id',
        asalSekolah: 'SMK Boash',
        kdProgstudi: '2',
        kdJenjang: '5',
        kdKelas: 'A',
        tahunMasuk: '2023/2024',
        status: '1',
        foto: '',
        googleId: '',
      );

      await SessionService.saveMahasiswa(initial);

      final retrieved = await SessionService.getMahasiswa();
      expect(retrieved, isNotNull);
      expect(retrieved!.npm, '12523030');
      expect(retrieved.nama, 'Sofi Arianti');
      expect(retrieved.isPerempuan, isTrue);

      final prodiCode = await SessionService.getProdiCode();
      expect(prodiCode, '2');

      await SessionService.clearAll();
      final cleared = await SessionService.getMahasiswa();
      expect(cleared, isNull);
    });
  });

  group('GenderAvatar Widget Tests', () {
    testWidgets('renders female avatar icon when isFemale is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GenderAvatar(isFemale: true, size: 60)),
        ),
      );

      expect(find.byIcon(Icons.face_3_rounded), findsOneWidget);
      expect(find.byIcon(Icons.face_6_rounded), findsNothing);
    });

    testWidgets('renders male avatar icon when isFemale is false', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: GenderAvatar(isFemale: false, size: 60)),
        ),
      );

      expect(find.byIcon(Icons.face_6_rounded), findsOneWidget);
      expect(find.byIcon(Icons.face_3_rounded), findsNothing);
    });
  });
}
