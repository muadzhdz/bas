import 'package:flutter/material.dart';

import '../api/krs_api.dart';
import '../models/krs_model.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';
import '../widgets/sweet_alert.dart';

class KrsScreen extends StatefulWidget {
  final UserModel? user;

  const KrsScreen({super.key, this.user});

  @override
  State<KrsScreen> createState() => _KrsScreenState();
}

class _KrsScreenState extends State<KrsScreen> {
  final KrsApi _krsApi = KrsApi();

  bool _isLoading = true;
  String? _errorMessage;
  List<KrsModel> _krsList = [];

  @override
  void initState() {
    super.initState();
    _loadKrs();
  }

  Future<void> _loadKrs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final npm = widget.user?.userid.toString() ?? '12523030';
    try {
      final list = await _krsApi.fetchKrsByNpm(npm);
      if (!mounted) return;
      setState(() {
        _krsList = list;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Gagal memuat data Kartu Rencana Studi.';
        _isLoading = false;
      });
    }
  }

  void _showAddKrsModal(BuildContext context) {
    MatkulCatalogItem selectedMatkul = MatkulCatalogItem.catalog.first;
    String selectedKelas = 'A';
    String selectedSemester = '2';
    String selectedTahunAkademik = '2024/2025';
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Form Pengajuan KRS',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(modalContext),
                          icon: const Icon(Icons.close_rounded),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const Text(
                      'Pilih mata kuliah dan kelas yang akan diajukan ke Dosen Wali.',
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Mata Kuliah',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<MatkulCatalogItem>(
                          value: selectedMatkul,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          items: MatkulCatalogItem.catalog.map((item) {
                            return DropdownMenuItem<MatkulCatalogItem>(
                              value: item,
                              child: Text(
                                '${item.kode} - ${item.nama} (${item.sks} SKS)',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: isSubmitting
                              ? null
                              : (item) {
                                  if (item != null) {
                                    setModalState(() => selectedMatkul = item);
                                  }
                                },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Kelas',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.offWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedKelas,
                                    isExpanded: true,
                                    items: ['A', 'B', 'C'].map((k) {
                                      return DropdownMenuItem<String>(
                                        value: k,
                                        child: Text(
                                          'Kelas $k',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: isSubmitting
                                        ? null
                                        : (val) {
                                            if (val != null) {
                                              setModalState(
                                                () => selectedKelas = val,
                                              );
                                            }
                                          },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Semester',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.offWhite,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedSemester,
                                    isExpanded: true,
                                    items: ['1', '2', '3', '4', '5', '6'].map((
                                      s,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: s,
                                        child: Text(
                                          'Semester $s',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.ink,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: isSubmitting
                                        ? null
                                        : (val) {
                                            if (val != null) {
                                              setModalState(
                                                () => selectedSemester = val,
                                              );
                                            }
                                          },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tahun Akademik',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedTahunAkademik,
                          isExpanded: true,
                          items: ['2024/2025', '2023/2024'].map((t) {
                            return DropdownMenuItem<String>(
                              value: t,
                              child: Text(
                                t,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: isSubmitting
                              ? null
                              : (val) {
                                  if (val != null) {
                                    setModalState(
                                      () => selectedTahunAkademik = val,
                                    );
                                  }
                                },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 18,
                            color: Color(0xFFD97706),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Pengajuan baru otomatis berstatus Menunggu Persetujuan (0) hingga disetujui Dosen Wali.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    FilledButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              final isAlreadyTaken = _krsList.any(
                                (k) =>
                                    k.kdMatkul.toUpperCase() ==
                                    selectedMatkul.kode.toUpperCase(),
                              );
                              if (isAlreadyTaken) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Mata kuliah ${selectedMatkul.nama} sudah ada di daftar KRS Anda.',
                                      ),
                                      backgroundColor: AppColors.danger,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                return;
                              }

                              setModalState(() => isSubmitting = true);
                              final studentNpm =
                                  widget.user?.userid.toString() ?? '12523030';
                              final created = await _krsApi.submitKrs(
                                npm: studentNpm,
                                kdMatkul: selectedMatkul.kode,
                                kdKelas: selectedKelas,
                                thnAkademik: selectedTahunAkademik,
                                semester: selectedSemester,
                                semesterNow:
                                    selectedSemester == '1' ||
                                        selectedSemester == '3' ||
                                        selectedSemester == '5'
                                    ? 'ganjil'
                                    : 'genap',
                              );

                              if (!modalContext.mounted) return;
                              Navigator.pop(modalContext);

                              if (created != null) {
                                if (context.mounted) {
                                  await SweetAlert.success(
                                    context: context,
                                    title: 'Pengajuan Berhasil!',
                                    message:
                                        '${selectedMatkul.nama} berhasil diajukan dengan status Menunggu Persetujuan.',
                                  );
                                }
                                _loadKrs();
                              } else {
                                if (context.mounted) {
                                  await SweetAlert.error(
                                    context: context,
                                    title: 'Pengajuan Gagal',
                                    message: 'Terjadi kendala saat mengirim pengajuan studi ke server MockAPI.',
                                  );
                                }
                              }
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: AppColors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Kirim Pengajuan KRS',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeleteKrs(KrsModel course) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Batalkan Pengajuan?',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
          ),
          content: Text(
            'Apakah Anda yakin ingin membatalkan pengajuan mata kuliah ${course.namaMatkul}?',
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                final success = await _krsApi.deleteKrs(course.id);
                if (!mounted) return;
                if (success) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Text(
                          'Pengajuan ${course.namaMatkul} berhasil dibatalkan.',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  _loadKrs();
                } else {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Gagal membatalkan pengajuan.'),
                        backgroundColor: AppColors.danger,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Batalkan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final studentName = widget.user?.nama.isNotEmpty == true
        ? widget.user!.nama
        : 'Sofi Arianti';
    final studentNpm = widget.user?.userid.toString() ?? '12523030';
    final totalSks = _krsList.fold(0, (sum, item) => sum + item.sks);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Kartu Rencana Studi (KRS)'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('Menyiapkan berkas KRS resmi (PDF)...'),
                    duration: Duration(milliseconds: 1400),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            icon: const Icon(Icons.print_rounded),
            tooltip: 'Cetak KRS',
          ),
          IconButton(
            onPressed: _loadKrs,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Segarkan',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddKrsModal(context),
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.navyDark,
        elevation: 3,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Ajukan Matkul',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _buildBody(studentName, studentNpm, totalSks),
    );
  }

  Widget _buildBody(String studentName, String studentNpm, int totalSks) {
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
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadKrs,
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

    return RefreshIndicator(
      onRefresh: _loadKrs,
      color: AppColors.navy,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        children: [
          _buildKrsHeader(studentName, studentNpm, totalSks),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mata Kuliah Terdaftar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_krsList.length} Matkul • $totalSks SKS',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_krsList.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.assignment_outlined,
                    size: 48,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum Ada Rencana Studi',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Gunakan tombol "Ajukan Matkul" di bawah untuk menambahkan mata kuliah ke Kartu Rencana Studi Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.muted),
                  ),
                  const SizedBox(height: 18),
                  OutlinedButton.icon(
                    onPressed: () => _showAddKrsModal(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Ajukan Sekarang'),
                  ),
                ],
              ),
            )
          else
            for (final course in _krsList) _buildCourseCard(course),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('KRS berhasil diunduh (PDF).'),
                    duration: Duration(milliseconds: 1400),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            icon: const Icon(Icons.download_rounded, color: AppColors.navyDark),
            label: const Text('Unduh Kartu Rencana Studi (PDF)'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.navyDark,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKrsHeader(String name, String npm, int totalSks) {
    String globalStatusLabel = 'Belum Ada Pengajuan';
    Color globalColor = const Color(0xFF64748B);
    Color globalBg = const Color(0xFFF1F5F9);
    Color globalBorder = const Color(0xFFCBD5E1);
    IconData globalIcon = Icons.help_outline_rounded;

    if (_krsList.isNotEmpty) {
      if (_krsList.any((k) => k.isRejected)) {
        globalStatusLabel = 'Ada Matkul Ditolak (2)';
        globalColor = const Color(0xFFDC2626);
        globalBg = const Color(0xFFDC2626).withValues(alpha: 0.18);
        globalBorder = const Color(0xFFF87171);
        globalIcon = Icons.cancel_rounded;
      } else if (_krsList.any((k) => k.isPending)) {
        globalStatusLabel = 'Menunggu Persetujuan (0)';
        globalColor = const Color(0xFFFBBF24);
        globalBg = const Color(0xFFD97706).withValues(alpha: 0.22);
        globalBorder = const Color(0xFFFBBF24);
        globalIcon = Icons.hourglass_top_rounded;
      } else {
        globalStatusLabel = 'Disetujui Dosen Wali (1)';
        globalColor = const Color(0xFF4ADE80);
        globalBg = const Color(0xFF16A34A).withValues(alpha: 0.22);
        globalBorder = const Color(0xFF4ADE80);
        globalIcon = Icons.verified_rounded;
      }
    }

    final semesterDisplay = _krsList.isNotEmpty
        ? 'Semester ${_krsList.first.semester} (${_krsList.first.semesterNow})'
        : 'Semester Aktif';
    final tahunDisplay = _krsList.isNotEmpty
        ? _krsList.first.thnAkademik
        : '2023/2024';

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
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: globalBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: globalBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(globalIcon, color: globalColor, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      globalStatusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: globalColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                semesterDisplay,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'NPM $npm • Teknologi Rekayasa Multimedia',
            style: const TextStyle(fontSize: 12, color: Color(0xFF9FB0C9)),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF1E3A5F)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricColumn('Beban SKS', '$totalSks / 24 SKS'),
              _buildMetricColumn('T.A.', tahunDisplay),
              _buildMetricColumn('Dosen Wali (DPA)', 'Dr. Ir. Boash, M.Kom.'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF9FB0C9)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(KrsModel course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  course.kdMatkul,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.namaMatkul,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kelas ${course.kdKelas} • Dosen: ${course.dosen}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${course.sks} SKS',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3.5,
                ),
                decoration: BoxDecoration(
                  color: course.statusBgColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: course.statusBorderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      course.statusIcon,
                      size: 12,
                      color: course.statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course.statusLabel} (${course.status})',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: course.statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (course.isPending)
                InkWell(
                  onTap: () => _confirmDeleteKrs(course),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.delete_outline_rounded,
                          size: 14,
                          color: AppColors.danger,
                        ),
                        SizedBox(width: 3),
                        Text(
                          'Batalkan',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.danger,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
