class NewsModel {
  final String judul;
  final String isi;
  final String tanggalPosting;
  final String sumber;

  const NewsModel({
    required this.judul,
    required this.isi,
    required this.tanggalPosting,
    required this.sumber,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      judul: (json['judul_berita'] ?? '').toString().trim(),
      isi: (json['isi_berita'] ?? '').toString().trim(),
      tanggalPosting: (json['tgl_posting_berita'] ?? '').toString().trim(),
      sumber: (json['berita_dari'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judul_berita': judul,
      'isi_berita': isi,
      'tgl_posting_berita': tanggalPosting,
      'berita_dari': sumber,
    };
  }
}
