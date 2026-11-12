class KehadiranModel {
  final int id;
  final String userId;
  final String jamLogin;
  final String kodeMatkul;
  final String kodeKelas;
  final String tanggal;
  final String keterangan;
  final String session;
  final String tahunAkademik;
  final String semester;
  final String bhadirCheck;

  const KehadiranModel({
    required this.id,
    required this.userId,
    required this.jamLogin,
    required this.kodeMatkul,
    required this.kodeKelas,
    required this.tanggal,
    required this.keterangan,
    required this.session,
    required this.tahunAkademik,
    required this.semester,
    required this.bhadirCheck,
  });

  factory KehadiranModel.fromJson(Map<String, dynamic> json) {
    return KehadiranModel(
      id: int.tryParse((json['id'] ?? '0').toString()) ?? 0,
      userId: (json['userid'] ?? '').toString().trim(),
      jamLogin: (json['jam_login'] ?? '').toString().trim(),
      kodeMatkul: (json['kd_matkul'] ?? '').toString().trim(),
      kodeKelas: (json['kd_kelas'] ?? '').toString().trim(),
      tanggal: (json['tanggal'] ?? '').toString().trim(),
      keterangan: (json['keterangan'] ?? '').toString().trim(),
      session: (json['session'] ?? '').toString().trim(),
      tahunAkademik: (json['thn_akademik'] ?? '').toString().trim(),
      semester: (json['semester'] ?? '').toString().trim(),
      bhadirCheck: (json['bhadir_check'] ?? '0').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id > 0) 'id': id,
      'userid': userId,
      'jam_login': jamLogin,
      'kd_matkul': kodeMatkul,
      'kd_kelas': kodeKelas,
      'tanggal': tanggal,
      'keterangan': keterangan,
      'session': session,
      'thn_akademik': tahunAkademik,
      'semester': semester,
      'bhadir_check': bhadirCheck,
    };
  }

  bool get isHadir => keterangan == '1' || keterangan.toLowerCase() == 'hadir';
}
