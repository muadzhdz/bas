class MahasiswaModel {
  final String npm;
  final String nama;
  final String tempatLahir;
  final String tglLahir;
  final String agama;
  final String kelamin;
  final String perkawinan;
  final String wargaNegara;
  final String alamat;
  final String cprovinsi;
  final String kodepos;
  final String tlpRumah;
  final String handphone;
  final String email;
  final String asalSekolah;
  final String kdProgstudi;
  final String kdJenjang;
  final String kdKelas;
  final String tahunMasuk;
  final String status;
  final String foto;
  final String googleId;

  MahasiswaModel({
    required this.npm,
    required this.nama,
    required this.tempatLahir,
    required this.tglLahir,
    required this.agama,
    required this.kelamin,
    required this.perkawinan,
    required this.wargaNegara,
    required this.alamat,
    required this.cprovinsi,
    required this.kodepos,
    required this.tlpRumah,
    required this.handphone,
    required this.email,
    required this.asalSekolah,
    required this.kdProgstudi,
    required this.kdJenjang,
    required this.kdKelas,
    required this.tahunMasuk,
    required this.status,
    required this.foto,
    required this.googleId,
  });

  bool get isPerempuan {
    final clean = kelamin.trim().toLowerCase();
    return clean == '0' || clean == 'p' || clean == 'perempuan';
  }

  String get jenisKelaminFormatted => isPerempuan ? 'Perempuan' : 'Laki-laki';

  String get namaProdi {
    switch (kdProgstudi.trim()) {
      case '2':
        return 'Teknologi Rekayasa Multimedia';
      case '1':
        return 'Teknik Informatika';
      case '3':
        return 'Sistem Informasi';
      case '4':
        return 'Bisnis Digital';
      default:
        return 'Teknologi Rekayasa Multimedia';
    }
  }

  String get kodeProdiFormatted =>
      kdProgstudi.trim().isNotEmpty ? kdProgstudi.trim() : '2';

  String get jenjangFormatted {
    switch (kdJenjang.trim()) {
      case '5':
        return 'D4 / Sarjana Terapan';
      case '4':
        return 'D3 / Ahli Madya';
      case '6':
        return 'S1 / Sarjana';
      default:
        return 'D4 / Sarjana Terapan';
    }
  }

  bool get isAktif => status.trim() == '1';

  String get statusMahasiswaLabel => isAktif ? 'Aktif' : 'Nonaktif';

  String get ttlFormatted {
    final tgl = tglLahir.trim();
    final tempat = tempatLahir.trim();
    if (tempat.isNotEmpty && tgl.isNotEmpty) {
      return '$tempat, $tgl';
    } else if (tempat.isNotEmpty) {
      return tempat;
    } else if (tgl.isNotEmpty) {
      return tgl;
    }
    return '-';
  }

  String get alamatLengkap {
    final parts = [
      alamat.trim(),
      cprovinsi.trim(),
      kodepos.trim().isNotEmpty ? 'Kode Pos ${kodepos.trim()}' : '',
    ].where((p) => p.isNotEmpty).toList();

    return parts.isNotEmpty ? parts.join(', ') : '-';
  }

  factory MahasiswaModel.fromJson(Map<String, dynamic> json) {
    return MahasiswaModel(
      npm: json['npm']?.toString().trim() ?? '',
      nama: json['nama']?.toString().trim() ?? '',
      tempatLahir: json['tempat_lahir']?.toString().trim() ?? '',
      tglLahir: json['tgl_lahir']?.toString().trim() ?? '',
      agama: json['agama']?.toString().trim() ?? '',
      kelamin: json['kelamin']?.toString().trim() ?? '0',
      perkawinan: json['perkawinan']?.toString().trim() ?? '',
      wargaNegara: json['warga_negara']?.toString().trim() ?? 'Indonesia',
      alamat: json['alamat']?.toString().trim() ?? '',
      cprovinsi: json['cprovinsi']?.toString().trim() ?? '',
      kodepos: json['kodepos']?.toString().trim() ?? '',
      tlpRumah: json['tlp_rumah']?.toString().trim() ?? '',
      handphone: json['handphone']?.toString().trim() ?? '',
      email: json['email']?.toString().trim() ?? '',
      asalSekolah: json['asal_sekolah']?.toString().trim() ?? '',
      kdProgstudi: json['kd_progstudi']?.toString().trim() ?? '2',
      kdJenjang: json['kd_jenjang']?.toString().trim() ?? '5',
      kdKelas: json['kd_kelas']?.toString().trim() ?? 'A',
      tahunMasuk: json['tahun_masuk']?.toString().trim() ?? '2023/2024',
      status: json['status']?.toString().trim() ?? '1',
      foto: json['foto']?.toString().trim() ?? '',
      googleId: json['google_id']?.toString().trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'npm': npm,
      'nama': nama,
      'tempat_lahir': tempatLahir,
      'tgl_lahir': tglLahir,
      'agama': agama,
      'kelamin': kelamin,
      'perkawinan': perkawinan,
      'warga_negara': wargaNegara,
      'alamat': alamat,
      'cprovinsi': cprovinsi,
      'kodepos': kodepos,
      'tlp_rumah': tlpRumah,
      'handphone': handphone,
      'email': email,
      'asal_sekolah': asalSekolah,
      'kd_progstudi': kdProgstudi,
      'kd_jenjang': kdJenjang,
      'kd_kelas': kdKelas,
      'tahun_masuk': tahunMasuk,
      'status': status,
      'foto': foto,
      'google_id': googleId,
    };
  }
}
