class NilaiModel {
  final int id;
  final String kdMatkul;
  final String npm;
  final double uas;
  final double uts;
  final double quis;
  final double tugas;
  final double hadir;
  final double naUas;
  final double naUts;
  final double naQuis;
  final double naTugas;
  final double naHadir;
  final String hm; // Huruf Mutu (e.g. A, B+, B)
  final double na; // Nilai Akhir angka (e.g. 79.3)
  final double am; // Angka Mutu (e.g. 3.5)
  final double mutu; // SKS * AM (e.g. 10.5)
  final String nip;
  final String thnAkademik;
  final String semester;
  final String dentry;

  NilaiModel({
    required this.id,
    required this.kdMatkul,
    required this.npm,
    required this.uas,
    required this.uts,
    required this.quis,
    required this.tugas,
    required this.hadir,
    required this.naUas,
    required this.naUts,
    required this.naQuis,
    required this.naTugas,
    required this.naHadir,
    required this.hm,
    required this.na,
    required this.am,
    required this.mutu,
    required this.nip,
    required this.thnAkademik,
    required this.semester,
    required this.dentry,
  });

  // Menghitung SKS dari rumus Mutu = SKS * AM
  int get sks {
    if (am > 0) {
      return (mutu / am).round();
    }
    return 3; // default SKS jika AM bernilai 0
  }

  // Nama mata kuliah representatif berdasarkan kode matkul
  String get namaMatkul {
    switch (kdMatkul.toUpperCase()) {
      case 'GC327':
        return 'Pemrograman Perangkat Bergerak';
      case 'GC302':
        return 'Sistem Basis Data Terdistribusi';
      default:
        return 'Mata Kuliah $kdMatkul';
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  factory NilaiModel.fromJson(Map<String, dynamic> json) {
    return NilaiModel(
      id: _parseInt(json['id']),
      kdMatkul: json['kd_matkul']?.toString() ?? '',
      npm: json['npm']?.toString() ?? '',
      uas: _parseDouble(json['uas']),
      uts: _parseDouble(json['uts']),
      quis: _parseDouble(json['quis']),
      tugas: _parseDouble(json['tugas']),
      hadir: _parseDouble(json['hadir']),
      naUas: _parseDouble(json['na_uas']),
      naUts: _parseDouble(json['na_uts']),
      naQuis: _parseDouble(json['na_quis']),
      naTugas: _parseDouble(json['na_tugas']),
      naHadir: _parseDouble(json['na_hadir']),
      hm: json['hm']?.toString().trim() ?? '-',
      na: _parseDouble(json['na']),
      am: _parseDouble(json['am']),
      mutu: _parseDouble(json['mutu']),
      nip: json['nip']?.toString() ?? '',
      thnAkademik: json['thn_akademik']?.toString() ?? '',
      semester: json['semester']?.toString() ?? '',
      dentry: json['dentry']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kd_matkul': kdMatkul,
      'npm': npm,
      'uas': uas.toString(),
      'uts': uts.toString(),
      'quis': quis.toString(),
      'tugas': tugas.toString(),
      'hadir': hadir.toString(),
      'na_uas': naUas.toString(),
      'na_uts': naUts.toString(),
      'na_quis': naQuis.toString(),
      'na_tugas': naTugas.toString(),
      'na_hadir': naHadir.toString(),
      'hm': hm,
      'na': na.toString(),
      'am': am.toString(),
      'mutu': mutu.toString(),
      'nip': nip,
      'thn_akademik': thnAkademik,
      'semester': semester,
      'dentry': dentry,
    };
  }
}

// Model ringkasan KHS (Indeks Prestasi Semester)
class KhsSummary {
  final List<NilaiModel> daftarNilai;

  KhsSummary(this.daftarNilai);

  int get totalSks => daftarNilai.fold(0, (sum, item) => sum + item.sks);

  double get totalMutu => daftarNilai.fold(0.0, (sum, item) => sum + item.mutu);

  double get ips {
    if (totalSks == 0) return 0.0;
    return totalMutu / totalSks;
  }

  String get ipsFormatted => ips.toStringAsFixed(2);

  String get thnAkademik =>
      daftarNilai.isNotEmpty ? daftarNilai.first.thnAkademik : '2023/2024';

  String get semester =>
      daftarNilai.isNotEmpty ? daftarNilai.first.semester : '1';
}
