class BimbinganModel {
  final String tahunAkademik;
  final String npm;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String judul;
  final String topik;
  final String permasalahan;
  final String nipDosen;
  final int proposal;
  final String skProposal;
  final int statusProposal;
  final String tugasAkhir;
  final String skTugasAkhir;
  final int statusTugasAkhir;
  final int statusData;

  const BimbinganModel({
    required this.tahunAkademik,
    required this.npm,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.judul,
    required this.topik,
    required this.permasalahan,
    required this.nipDosen,
    required this.proposal,
    required this.skProposal,
    required this.statusProposal,
    required this.tugasAkhir,
    required this.skTugasAkhir,
    required this.statusTugasAkhir,
    required this.statusData,
  });

  factory BimbinganModel.fromJson(Map<String, dynamic> json) {
    return BimbinganModel(
      tahunAkademik: (json['thn_akademik'] ?? '').toString().trim(),
      npm: (json['npm'] ?? '').toString().trim(),
      tanggalMulai: (json['tgl_mulai'] ?? '').toString().trim(),
      tanggalSelesai: (json['tgl_selesai'] ?? '').toString().trim(),
      judul: (json['judul'] ?? '').toString().trim(),
      topik: (json['topik'] ?? '').toString().trim(),
      permasalahan: (json['permasalahan'] ?? '').toString().trim(),
      nipDosen: (json['nip'] ?? '').toString().trim(),
      proposal: int.tryParse((json['proposal'] ?? '0').toString()) ?? 0,
      skProposal: (json['sk_proposal'] ?? '').toString().trim(),
      statusProposal:
          int.tryParse((json['status_proposal'] ?? '0').toString()) ?? 0,
      tugasAkhir: (json['tugas_akhir'] ?? '').toString().trim(),
      skTugasAkhir: (json['sk_tugas_akhir'] ?? '').toString().trim(),
      statusTugasAkhir:
          int.tryParse((json['status_tugas_akhir'] ?? '0').toString()) ?? 0,
      statusData: int.tryParse((json['status_data'] ?? '0').toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'thn_akademik': tahunAkademik,
      'npm': npm,
      'tgl_mulai': tanggalMulai,
      'tgl_selesai': tanggalSelesai,
      'judul': judul,
      'topik': topik,
      'permasalahan': permasalahan,
      'nip': nipDosen,
      'proposal': proposal,
      'sk_proposal': skProposal,
      'status_proposal': statusProposal,
      'tugas_akhir': tugasAkhir,
      'sk_tugas_akhir': skTugasAkhir,
      'status_tugas_akhir': statusTugasAkhir,
      'status_data': statusData,
    };
  }

  bool get isProposalApproved => statusProposal == 1;
  bool get isTugasAkhirCompleted => statusTugasAkhir == 1;
}
