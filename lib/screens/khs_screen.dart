import 'package:flutter/material.dart';

import '../api/nilai_api.dart';
import '../models/nilai_model.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class KhsScreen extends StatefulWidget {
  final UserModel? user;

  const KhsScreen({super.key, this.user});

  @override
  State<KhsScreen> createState() => _KhsScreenState();
}

class _KhsScreenState extends State<KhsScreen> {
  final NilaiApi _nilaiApi = NilaiApi();

  bool _isLoading = true;
  String? _errorMessage;
  KhsSummary? _summary;
  String _selectedSemester = 'Semua';

  static const List<String> _semesterOptions = [
    'Semua',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
  ];

  @override
  void initState() {
    super.initState();
    _loadNilai();
  }

  Future<void> _loadNilai() async {
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
        _errorMessage = 'Gagal memuat data KHS. Periksa koneksi internet Anda.';
        _isLoading = false;
      });
    }
  }

  void _showDetailModal(BuildContext context, NilaiModel nilai) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      nilai.kdMatkul,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nilai.namaMatkul,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${nilai.sks} SKS • Dosen: ${nilai.nip}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.goldSoft,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.gold, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        nilai.hm,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(color: AppColors.border),
              const SizedBox(height: 10),
              const Text(
                'Rincian Komponen Penilaian',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              _buildComponentRow(
                'Presensi / Kehadiran',
                '${nilai.hadir}%',
                nilai.naHadir,
              ),
              _buildComponentRow(
                'Tugas Mandiri',
                nilai.tugas.toString(),
                nilai.naTugas,
              ),
              _buildComponentRow(
                'Kuis Perkuliahan',
                nilai.quis.toString(),
                nilai.naQuis,
              ),
              _buildComponentRow(
                'Ujian Tengah Semester (UTS)',
                nilai.uts.toString(),
                nilai.naUts,
              ),
              _buildComponentRow(
                'Ujian Akhir Semester (UAS)',
                nilai.uas.toString(),
                nilai.naUas,
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nilai Akhir (NA) / Mutu',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      '${nilai.na}  (Mutu: ${nilai.mutu})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Dicatat pada: ${nilai.dentry}',
                style: const TextStyle(fontSize: 11, color: AppColors.muted),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComponentRow(String label, String rawValue, double naValue) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ),
          Text(
            rawValue,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: 55,
            child: Text(
              naValue.toStringAsFixed(1),
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Kartu Hasil Studi (KHS)'),
        actions: [
          IconButton(
            onPressed: _loadNilai,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan KHS',
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
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.ink, fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadNilai,
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

    final fullSummary = _summary;
    if (fullSummary == null || fullSummary.daftarNilai.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada data nilai yang terdaftar.',
          style: TextStyle(color: AppColors.muted),
        ),
      );
    }

    final filteredSummary = fullSummary.filterBySemester(_selectedSemester);
    final studentName = widget.user?.nama.isNotEmpty == true
        ? widget.user!.nama
        : 'Sofi Arianti';
    final studentNpm = widget.user?.userid.toString() ?? '12523030';

    return RefreshIndicator(
      onRefresh: _loadNilai,
      color: AppColors.navy,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryHero(studentName, studentNpm, filteredSummary),
          const SizedBox(height: 18),
          _buildSemesterFilter(),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _selectedSemester == 'Semua'
                    ? 'Seluruh Mata Kuliah'
                    : 'Nilai Semester $_selectedSemester',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              Text(
                '${filteredSummary.daftarNilai.length} Mata Kuliah',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (filteredSummary.daftarNilai.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.folder_open_rounded,
                    size: 44,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Belum Ada Nilai di Semester $_selectedSemester',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Nilai untuk semester ini belum diterbitkan oleh bagian akademik.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                ],
              ),
            )
          else
            for (final nilai in filteredSummary.daftarNilai)
              _buildMatkulCard(nilai),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              final target = _selectedSemester == 'Semua'
                  ? 'Kumulatif'
                  : 'Semester $_selectedSemester';
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Mengunduh KHS $target dalam format PDF...'),
                    duration: const Duration(milliseconds: 1400),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            icon: const Icon(Icons.download_rounded, color: AppColors.navyDark),
            label: Text(
              _selectedSemester == 'Semua'
                  ? 'Unduh KHS Kumulatif (PDF)'
                  : 'Unduh KHS Semester $_selectedSemester (PDF)',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.navyDark,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Filter Semester:',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _semesterOptions.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final opt = _semesterOptions[index];
              final isSelected = _selectedSemester == opt;
              final label = opt == 'Semua' ? 'Semua Semester' : 'Semester $opt';

              return ChoiceChip(
                label: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? AppColors.white : AppColors.ink,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.navy,
                backgroundColor: AppColors.offWhite,
                showCheckmark: false,
                side: BorderSide(
                  color: isSelected ? AppColors.navy : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _selectedSemester = opt);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryHero(String name, String npm, KhsSummary summary) {
    final semesterSubtitle = _selectedSemester == 'Semua'
        ? 'Semua Semester • T.A. ${summary.thnAkademik}'
        : 'Semester $_selectedSemester • T.A. ${summary.thnAkademik}';

    final scoreLabel = _selectedSemester == 'Semua'
        ? 'IPK KUMULATIF'
        : 'IP SEMESTER';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navyDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NPM $npm',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9FB0C9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      semesterSubtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      scoreLabel,
                      style: const TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.1,
                        fontWeight: FontWeight.w800,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      summary.ipsFormatted,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0xFF1E3A5F)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMetricItem('Beban SKS', '${summary.totalSks} SKS'),
              Container(width: 1, height: 26, color: const Color(0xFF1E3A5F)),
              _buildMetricItem(
                'Total Mutu',
                summary.totalMutu.toStringAsFixed(1),
              ),
              Container(width: 1, height: 26, color: const Color(0xFF1E3A5F)),
              _buildMetricItem(
                'Predikat',
                summary.ips >= 3.5
                    ? 'Dengan Pujian'
                    : summary.ips >= 3.0
                    ? 'Sangat Baik'
                    : 'Baik',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9FB0C9)),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMatkulCard(NilaiModel nilai) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDetailModal(context, nilai),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.goldSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      nilai.hm,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.offWhite,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              nilai.kdMatkul,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.navy,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${nilai.sks} SKS • Smt ${nilai.semester}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        nilai.namaMatkul,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Nilai Akhir: ${nilai.na} • Bobot: ${nilai.am}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.muted,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
