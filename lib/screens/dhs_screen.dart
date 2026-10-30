import 'package:flutter/material.dart';

import '../api/nilai_api.dart';
import '../models/nilai_model.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class DhsScreen extends StatefulWidget {
  final UserModel? user;

  const DhsScreen({super.key, this.user});

  @override
  State<DhsScreen> createState() => _DhsScreenState();
}

class _DhsScreenState extends State<DhsScreen> {
  final NilaiApi _nilaiApi = NilaiApi();
  bool _isLoading = true;
  String? _errorMessage;
  KhsSummary? _summary;

  @override
  void initState() {
    super.initState();
    _loadDhs();
  }

  Future<void> _loadDhs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final npm = widget.user?.userid.toString() ?? '12523030';
    try {
      final summary = await _nilaiApi.fetchKhsSummary(npm);
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Gagal memuat Daftar Hasil Studi.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Daftar Hasil Studi (DHS)'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Menyiapkan cetak transkrip resmi PDF...'),
                    duration: Duration(milliseconds: 1400),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            icon: const Icon(Icons.print_rounded),
            tooltip: 'Cetak Transkrip',
          ),
          IconButton(
            onPressed: _loadDhs,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan Data',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.navy,
          strokeWidth: 2.5,
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.danger,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(_errorMessage!, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadDhs,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final summary = _summary;
    if (summary == null || summary.daftarNilai.isEmpty) {
      return const Center(child: Text('Data transkrip nilai belum tersedia.'));
    }

    final studentName = widget.user?.nama.isNotEmpty == true
        ? widget.user!.nama
        : 'Sofi Arianti';
    final studentNpm = widget.user?.userid.toString() ?? '12523030';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
      child: Column(
        children: [
          // Lembar Dokumen Transkrip Resmi
          _buildTranscriptDocument(studentName, studentNpm, summary),
          const SizedBox(height: 20),

          // Tombol Aksi Cetak & Unduh
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Transkrip DHS (PDF) berhasil diunduh.',
                          ),
                          duration: Duration(milliseconds: 1400),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                  icon: const Icon(
                    Icons.download_rounded,
                    color: AppColors.navyDark,
                  ),
                  label: const Text('Unduh Transkrip PDF'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.navyDark,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptDocument(String name, String npm, KhsSummary summary) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Security Watermark: Logo Boash dengan opacity 7% di tengah transkrip
            Positioned.fill(
              child: Center(
                child: Opacity(
                  opacity: 0.07,
                  child: Image.asset(
                    'assets/images/boash.png',
                    width: 260,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Konten Dokumen Transkrip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 1. Kop Surat Institusi Resmi
                  _buildInstitutionalHeader(),
                  const SizedBox(height: 14),

                  // Garis Ganda Kop Surat
                  Column(
                    children: [
                      Container(height: 2.5, color: AppColors.navy),
                      const SizedBox(height: 1.5),
                      Container(height: 0.8, color: AppColors.navy),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Judul Dokumen
                  const Center(
                    child: Text(
                      'DAFTAR HASIL STUDI (DHS) / TRANSKRIP AKADEMIK SEMENTARA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Nomor Dokumen: 2024/TR-DHS/014/VIII',
                      style: TextStyle(fontSize: 10, color: AppColors.muted),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // 2. Data Mahasiswa (Formal 2 Kolom)
                  _buildStudentInfoGrid(name, npm),
                  const SizedBox(height: 20),

                  // 3. Tabel Transkrip Nilai Akademik
                  _buildTranscriptTable(summary.daftarNilai),
                  const SizedBox(height: 18),

                  // 4. Rekapitulasi Prestasi Akademik (SKS, Mutu, IPK)
                  _buildSummaryBox(summary),
                  const SizedBox(height: 28),

                  // 5. Tanda Tangan & Legalisasi Digital
                  _buildSignaturesSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstitutionalHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/boash.png',
          width: 58,
          height: 58,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'UNIVERSITAS BOASH',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: AppColors.navy,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'FAKULTAS TEKNOLOGI INFORMASI & MULTIMEDIA',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Jl. Boash No. 1, Bogor Barat • Akreditasi BAN-PT: Unggul',
                style: TextStyle(fontSize: 10, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStudentInfoGrid(String name, String npm) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildInfoItem('Nama Mahasiswa', name)),
              Expanded(
                child: _buildInfoItem(
                  'Program Studi',
                  'Teknologi Rekayasa Multimedia',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildInfoItem('Nomor Pokok (NPM)', npm)),
              Expanded(
                child: _buildInfoItem(
                  'Jenjang Pendidikan',
                  'Sarjana Terapan (S1 / D4)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('Tahun Masuk / Angkatan', '2023 / 2024'),
              ),
              Expanded(
                child: _buildInfoItem(
                  'Status Registrasi',
                  'Aktif (Terdaftar PDDikti)',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.muted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }

  Widget _buildTranscriptTable(List<NilaiModel> list) {
    return Column(
      children: [
        // Table Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: const BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            children: const [
              SizedBox(
                width: 26,
                child: Text(
                  'No',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  'Kode',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'Mata Kuliah',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  'SKS',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  'HM',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 32,
                child: Text(
                  'AM',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 38,
                child: Text(
                  'Mutu',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),

        // Table Rows
        for (int i = 0; i < list.length; i++) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
            decoration: BoxDecoration(
              color: i.isEven ? AppColors.white : const Color(0xFFFBFBFD),
              border: const Border(
                left: BorderSide(color: AppColors.border),
                right: BorderSide(color: AppColors.border),
                bottom: BorderSide(color: AppColors.border),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 26,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.muted,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    list[i].kdMatkul,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    list[i].namaMatkul,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    '${list[i].sks}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    list[i].hm,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    list[i].am.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 11),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 38,
                  child: Text(
                    list[i].mutu.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSummaryBox(KhsSummary summary) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.goldSoft.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryMetric('Total SKS', '${summary.totalSks} SKS'),
          Container(
            width: 1,
            height: 32,
            color: AppColors.gold.withValues(alpha: 0.4),
          ),
          _buildSummaryMetric(
            'Total Mutu',
            summary.totalMutu.toStringAsFixed(1),
          ),
          Container(
            width: 1,
            height: 32,
            color: AppColors.gold.withValues(alpha: 0.4),
          ),
          _buildSummaryMetric(
            'IP Kumulatif (IPK)',
            summary.ipsFormatted,
            isHighlighted: true,
          ),
          Container(
            width: 1,
            height: 32,
            color: AppColors.gold.withValues(alpha: 0.4),
          ),
          _buildSummaryMetric('Predikat', 'Sangat Memuaskan'),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric(
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.muted,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlighted ? 15 : 12,
            fontWeight: FontWeight.w800,
            color: isHighlighted ? AppColors.navy : AppColors.ink,
          ),
        ),
      ],
    );
  }

  Widget _buildSignaturesSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Verifikasi Digital / Cap QR
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.qr_code_2_rounded,
                size: 48,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Dokumen ini diterbitkan sah secara digital\nmelalui SIAKAD Universitas Boash.',
              style: TextStyle(fontSize: 8.5, color: AppColors.muted),
            ),
          ],
        ),

        // Tanda Tangan Dekan / BAAK
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              'Bogor, 23 Oktober 2024',
              style: TextStyle(fontSize: 10, color: AppColors.ink),
            ),
            SizedBox(height: 2),
            Text(
              'a.n. Dekan Fakultas,',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
            ),
            Text(
              'Kepala Biro Administrasi Akademik',
              style: TextStyle(fontSize: 9.5, color: AppColors.muted),
            ),
            SizedBox(height: 40),
            Text(
              'Dr. Ir. H. Boash Sujana, M.Kom.',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'NIP. 19780512 200312 1 002',
              style: TextStyle(fontSize: 9.5, color: AppColors.muted),
            ),
          ],
        ),
      ],
    );
  }
}
