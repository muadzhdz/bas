class InfoModel {
  final String id;
  final int kodeProdi;
  final String judul;
  final String isi;
  final String? tanggalPosting;
  final String sumber;

  const InfoModel({
    required this.id,
    required this.kodeProdi,
    required this.judul,
    required this.isi,
    this.tanggalPosting,
    required this.sumber,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      id: (json['id_informasi'] ?? '').toString().trim(),
      kodeProdi: int.tryParse((json['kd_progstudi'] ?? '0').toString()) ?? 0,
      judul: (json['judul_informasi'] ?? '').toString().trim(),
      isi: (json['isi_informasi'] ?? '').toString().trim(),
      tanggalPosting: json['tgl_posting_informasi']?.toString().trim(),
      sumber: (json['informasi_dari'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_informasi': id,
      'kd_progstudi': kodeProdi,
      'judul_informasi': judul,
      'isi_informasi': isi,
      'tgl_posting_informasi': tanggalPosting,
      'informasi_dari': sumber,
    };
  }
}
