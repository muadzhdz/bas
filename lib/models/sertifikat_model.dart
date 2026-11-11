class SertifikatModel {
  final String id;
  final String npm;
  final String nama;
  final String jenis;
  final String kategori;
  final String penyelenggara;
  final String tingkat;
  final String nomor;
  final String file;
  final int tanggalSertifikat;
  final int tanggalUpload;
  final String statusVerifikasi;
  final String catatanVerifikasi;
  final String diverifikasiOleh;
  final int? tanggalVerifikasi;

  const SertifikatModel({
    required this.id,
    required this.npm,
    required this.nama,
    required this.jenis,
    required this.kategori,
    required this.penyelenggara,
    required this.tingkat,
    required this.nomor,
    required this.file,
    required this.tanggalSertifikat,
    required this.tanggalUpload,
    required this.statusVerifikasi,
    required this.catatanVerifikasi,
    required this.diverifikasiOleh,
    this.tanggalVerifikasi,
  });

  factory SertifikatModel.fromJson(Map<String, dynamic> json) {
    return SertifikatModel(
      id: (json['id_sertifikat'] ?? '').toString().trim(),
      npm: (json['npm'] ?? '').toString().trim(),
      nama: (json['nama_sertifikat'] ?? '').toString().trim(),
      jenis: (json['jenis_sertifikat'] ?? '').toString().trim(),
      kategori: (json['kategori_sertifikat'] ?? '').toString().trim(),
      penyelenggara: (json['penyelenggara'] ?? '').toString().trim(),
      tingkat: (json['tingkat_kegiatan'] ?? '').toString().trim(),
      nomor: (json['nomor_sertifikat'] ?? '').toString().trim(),
      file: (json['file_sertifikat'] ?? '').toString().trim(),
      tanggalSertifikat:
          int.tryParse((json['tanggal_sertifikat'] ?? '0').toString()) ?? 0,
      tanggalUpload:
          int.tryParse((json['tanggal_upload'] ?? '0').toString()) ?? 0,
      statusVerifikasi: (json['status_verifikasi'] ?? '').toString().trim(),
      catatanVerifikasi: (json['catatan_verifikasi'] ?? '').toString().trim(),
      diverifikasiOleh: (json['diverifikasi_oleh'] ?? '').toString().trim(),
      tanggalVerifikasi: json['tanggal_verifikasi'] != null
          ? int.tryParse(json['tanggal_verifikasi'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_sertifikat': id,
      'npm': npm,
      'nama_sertifikat': nama,
      'jenis_sertifikat': jenis,
      'kategori_sertifikat': kategori,
      'penyelenggara': penyelenggara,
      'tingkat_kegiatan': tingkat,
      'nomor_sertifikat': nomor,
      'file_sertifikat': file,
      'tanggal_sertifikat': tanggalSertifikat,
      'tanggal_upload': tanggalUpload,
      'status_verifikasi': statusVerifikasi,
      'catatan_verifikasi': catatanVerifikasi,
      'diverifikasi_oleh': diverifikasiOleh,
      'tanggal_verifikasi': tanggalVerifikasi,
    };
  }

  bool get isVerified {
    final lower = statusVerifikasi.toLowerCase();
    return lower.contains('terverifikasi') ||
        lower.contains('verified') ||
        lower.contains('disetujui');
  }

  bool get isPending {
    final lower = statusVerifikasi.toLowerCase();
    return lower.contains('menunggu') ||
        lower.contains('pending') ||
        lower.isEmpty;
  }

  String get formattedDate {
    if (tanggalSertifikat <= 0) return '-';
    final date = DateTime.fromMillisecondsSinceEpoch(tanggalSertifikat * 1000);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
