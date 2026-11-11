class FinanceModel {
  final int id;
  final String npm;
  final String tahunAkademik;
  final String semester;
  final String tanggalBayar;
  final int nominal;
  final String keterangan;
  final String? regId;

  const FinanceModel({
    required this.id,
    required this.npm,
    required this.tahunAkademik,
    required this.semester,
    required this.tanggalBayar,
    required this.nominal,
    required this.keterangan,
    this.regId,
  });

  factory FinanceModel.fromJson(Map<String, dynamic> json) {
    final rawNominal = (json['npayment'] ?? '0').toString();
    final parsedNominal =
        int.tryParse(rawNominal.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    return FinanceModel(
      id: int.tryParse((json['nid'] ?? '0').toString()) ?? 0,
      npm: (json['npm'] ?? '').toString().trim(),
      tahunAkademik: (json['thn_akademik'] ?? '').toString().trim(),
      semester: (json['semester'] ?? '').toString().trim(),
      tanggalBayar: (json['dpayment'] ?? '').toString().trim(),
      nominal: parsedNominal,
      keterangan: (json['cketerangan'] ?? '').toString().trim(),
      regId: json['reg_id']?.toString().trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nid': id,
      'npm': npm,
      'thn_akademik': tahunAkademik,
      'semester': semester,
      'dpayment': tanggalBayar,
      'npayment': nominal.toString(),
      'cketerangan': keterangan,
      'reg_id': regId,
    };
  }

  String get formattedNominal {
    final str = nominal.toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      buffer.write(str[i]);
      count++;
      if (count % 3 == 0 && i > 0) {
        buffer.write('.');
      }
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }
}
