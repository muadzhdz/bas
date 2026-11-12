import 'package:flutter/material.dart';

class KrsModel {
  final String id;
  final String npm;
  final String kdMatkul;
  final String kdKelas;
  final String thnAkademik;
  final String semester;
  final String thnAkademikNow;
  final String semesterNow;
  final int status;

  KrsModel({
    required this.id,
    required this.npm,
    required this.kdMatkul,
    required this.kdKelas,
    required this.thnAkademik,
    required this.semester,
    required this.thnAkademikNow,
    required this.semesterNow,
    required this.status,
  });

  bool get isApproved => status == 1;
  bool get isPending => status == 0;
  bool get isRejected => status == 2;

  String get statusLabel {
    switch (status) {
      case 1:
        return 'Disetujui Dosen Wali';
      case 0:
        return 'Menunggu Persetujuan';
      case 2:
        return 'Ditolak Dosen Wali';
      default:
        return 'Status Tidak Diketahui';
    }
  }

  Color get statusColor {
    switch (status) {
      case 1:
        return const Color(0xFF16A34A);
      case 0:
        return const Color(0xFFD97706);
      case 2:
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF64748B);
    }
  }

  Color get statusBgColor {
    switch (status) {
      case 1:
        return const Color(0xFFDCFCE7);
      case 0:
        return const Color(0xFFFEF3C7);
      case 2:
        return const Color(0xFFFEE2E2);
      default:
        return const Color(0xFFF1F5F9);
    }
  }

  Color get statusBorderColor {
    switch (status) {
      case 1:
        return const Color(0xFF86EFAC);
      case 0:
        return const Color(0xFFFDE68A);
      case 2:
        return const Color(0xFFFCA5A5);
      default:
        return const Color(0xFFCBD5E1);
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 1:
        return Icons.verified_rounded;
      case 0:
        return Icons.hourglass_top_rounded;
      case 2:
        return Icons.cancel_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  String get namaMatkul {
    switch (kdMatkul.toUpperCase()) {
      case 'GC327':
        return 'Pemrograman Perangkat Bergerak';
      case 'GC311':
        return 'Animasi & Pemodelan 3D';
      case 'GC319':
        return 'Rekayasa Multimedia Terapan';
      case 'GC302':
        return 'Sistem Basis Data Terdistribusi';
      case 'GC330':
        return 'Pemrograman Berorientasi Objek';
      case 'GC333':
        return 'Jaringan Komputer & Cloud';
      case 'GC334':
        return 'Desain Pengalaman Pengguna (UI/UX)';
      case 'GC335':
        return 'Pemrograman Web Lanjut';
      case 'GC336':
        return 'Etika Profesi & Komunikasi';
      default:
        return 'Mata Kuliah $kdMatkul';
    }
  }

  int get sks {
    switch (kdMatkul.toUpperCase()) {
      case 'GC336':
        return 2;
      default:
        return 3;
    }
  }

  String get jadwal {
    switch (kdMatkul.toUpperCase()) {
      case 'GC327':
        return 'Senin, 08:00 - 10:30 (R. Lab Mobile)';
      case 'GC311':
        return 'Selasa, 10:00 - 12:30 (R. Lab Studio)';
      case 'GC319':
        return 'Rabu, 13:00 - 15:30 (R. 302)';
      case 'GC302':
        return 'Kamis, 08:00 - 10:30 (R. Lab Basis Data)';
      case 'GC330':
        return 'Senin, 10:30 - 13:00 (R. Lab 1)';
      case 'GC333':
        return 'Kamis, 10:30 - 13:00 (R. Lab Net)';
      case 'GC334':
        return 'Jumat, 09:00 - 11:30 (R. 204)';
      case 'GC335':
        return 'Kamis, 13:30 - 16:00 (R. Lab 2)';
      case 'GC336':
        return 'Rabu, 10:00 - 11:40 (R. 101)';
      default:
        return 'Sesuai Jadwal Perkuliahan';
    }
  }

  String get dosen {
    switch (kdMatkul.toUpperCase()) {
      case 'GC327':
        return 'LU0512';
      case 'GC311':
        return 'AT2047';
      case 'GC319':
        return 'RM0311';
      case 'GC302':
        return 'AT1003';
      case 'GC330':
        return 'LU0512';
      case 'GC333':
        return 'NW0124';
      case 'GC334':
        return 'UX0981';
      case 'GC335':
        return 'WB0452';
      case 'GC336':
        return 'ET0219';
      default:
        return 'Dosen Pengampu';
    }
  }

  factory KrsModel.fromJson(Map<String, dynamic> json) {
    return KrsModel(
      id: json['id']?.toString() ?? '',
      npm: json['npm']?.toString() ?? '',
      kdMatkul: json['kd_matkul']?.toString() ?? '',
      kdKelas: json['kd_kelas']?.toString() ?? 'A',
      thnAkademik: json['thn_akademik']?.toString() ?? '2023/2024',
      semester: json['semester']?.toString() ?? '1',
      thnAkademikNow: json['thn_akademik_now']?.toString() ?? '2023/2024',
      semesterNow: json['semester_now']?.toString() ?? 'ganjil',
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'npm': npm,
      'kd_matkul': kdMatkul,
      'kd_kelas': kdKelas,
      'thn_akademik': thnAkademik,
      'semester': semester,
      'thn_akademik_now': thnAkademikNow,
      'semester_now': semesterNow,
      'status': status,
    };
  }
}

class MatkulCatalogItem {
  final String kode;
  final String nama;
  final int sks;

  const MatkulCatalogItem({
    required this.kode,
    required this.nama,
    required this.sks,
  });

  static const List<MatkulCatalogItem> catalog = [
    MatkulCatalogItem(
      kode: 'GC327',
      nama: 'Pemrograman Perangkat Bergerak',
      sks: 3,
    ),
    MatkulCatalogItem(kode: 'GC311', nama: 'Animasi & Pemodelan 3D', sks: 3),
    MatkulCatalogItem(
      kode: 'GC319',
      nama: 'Rekayasa Multimedia Terapan',
      sks: 3,
    ),
    MatkulCatalogItem(
      kode: 'GC302',
      nama: 'Sistem Basis Data Terdistribusi',
      sks: 3,
    ),
    MatkulCatalogItem(
      kode: 'GC330',
      nama: 'Pemrograman Berorientasi Objek',
      sks: 3,
    ),
    MatkulCatalogItem(kode: 'GC333', nama: 'Jaringan Komputer & Cloud', sks: 3),
    MatkulCatalogItem(
      kode: 'GC334',
      nama: 'Desain Pengalaman Pengguna (UI/UX)',
      sks: 3,
    ),
    MatkulCatalogItem(kode: 'GC335', nama: 'Pemrograman Web Lanjut', sks: 3),
    MatkulCatalogItem(
      kode: 'GC336',
      nama: 'Etika Profesi & Komunikasi',
      sks: 2,
    ),
  ];
}
