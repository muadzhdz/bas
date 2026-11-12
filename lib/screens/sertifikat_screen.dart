import 'package:flutter/material.dart';

import '../api/sertifikat_api.dart';
import '../models/sertifikat_model.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class SertifikatScreen extends StatefulWidget {
  final UserModel? user;

  const SertifikatScreen({super.key, this.user});

  @override
  State<SertifikatScreen> createState() => _SertifikatScreenState();
}

class _SertifikatScreenState extends State<SertifikatScreen> {
  final SertifikatApi _sertifikatApi = SertifikatApi();
  late Future<List<SertifikatModel>> _sertifikatFuture;

  @override
  void initState() {
    super.initState();
    _loadSertifikat();
  }

  void _loadSertifikat() {
    final npm = widget.user?.userid.toString() ?? '12523030';
    setState(() {
      _sertifikatFuture = _sertifikatApi.fetchSertifikatByNpm(npm);
    });
  }

  Future<void> _handleRefresh() async {
    _loadSertifikat();
    await _sertifikatFuture;
  }

  void _showDetail(BuildContext context, SertifikatModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.goldSoft,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.tingkat.isNotEmpty
                          ? item.tingkat
                          : 'Tingkat Nasional',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _statusBadge(item),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                item.nama,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),
              _detailRow(
                'Nomor Sertifikat',
                item.nomor.isNotEmpty ? item.nomor : '-',
              ),
              _detailRow(
                'Penyelenggara',
                item.penyelenggara.isNotEmpty ? item.penyelenggara : '-',
              ),
              _detailRow(
                'Jenis Kegiatan',
                item.jenis.isNotEmpty ? item.jenis : '-',
              ),
              _detailRow(
                'Kategori',
                item.kategori.isNotEmpty ? item.kategori : '-',
              ),
              _detailRow('Tanggal Perolehan', item.formattedDate),
              if (item.catatanVerifikasi.isNotEmpty)
                _detailRow('Catatan', item.catatanVerifikasi),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.ink,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddModal(BuildContext context) {
    final namaController = TextEditingController();
    final jenisController = TextEditingController(text: 'Pelatihan');
    final kategoriController = TextEditingController(text: 'Akademik');
    final penyelenggaraController = TextEditingController();
    final tingkatController = TextEditingController(text: 'Nasional');
    final nomorController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => StatefulBuilder(
        builder: (builderContext, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(builderContext).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
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
                const Text(
                  'Unggah Sertifikat Baru',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 16),
                _formField(
                  controller: namaController,
                  label: 'Nama Sertifikat / Kegiatan',
                  hint: 'Misal: Juara 1 UI/UX Design Competition',
                ),
                const SizedBox(height: 12),
                _formField(
                  controller: penyelenggaraController,
                  label: 'Penyelenggara',
                  hint: 'Misal: Kementerian Kominfo / Universitas',
                ),
                const SizedBox(height: 12),
                _formField(
                  controller: nomorController,
                  label: 'Nomor Sertifikat',
                  hint: 'Misal: SK/042/CERT/2026',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _formField(
                        controller: jenisController,
                        label: 'Jenis',
                        hint: 'Pelatihan / Lomba',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _formField(
                        controller: tingkatController,
                        label: 'Tingkat',
                        hint: 'Nasional / Kampus',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            final nama = namaController.text.trim();
                            final penyelenggara = penyelenggaraController.text
                                .trim();
                            final nomor = nomorController.text.trim();

                            if (nama.isEmpty ||
                                penyelenggara.isEmpty ||
                                nomor.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Lengkapi semua data sertifikat!',
                                  ),
                                  backgroundColor: AppColors.danger,
                                ),
                              );
                              return;
                            }

                            setModalState(() => isSubmitting = true);
                            final currentEpoch =
                                DateTime.now().millisecondsSinceEpoch ~/ 1000;
                            final npm =
                                widget.user?.userid.toString() ?? '12523030';

                            final newModel = SertifikatModel(
                              id: '',
                              npm: npm,
                              nama: nama,
                              jenis: jenisController.text.trim(),
                              kategori: kategoriController.text.trim(),
                              penyelenggara: penyelenggara,
                              tingkat: tingkatController.text.trim(),
                              nomor: nomor,
                              file: 'sertifikat_$currentEpoch.pdf',
                              tanggalSertifikat: currentEpoch,
                              tanggalUpload: currentEpoch,
                              statusVerifikasi: 'Menunggu Verifikasi',
                              catatanVerifikasi: '-',
                              diverifikasiOleh: '-',
                            );

                            final messenger = ScaffoldMessenger.of(context);
                            final success = await _sertifikatApi
                                .createSertifikat(newModel);

                            if (!mounted) return;
                            if (modalContext.mounted) {
                              Navigator.pop(modalContext);
                            }
                            if (success) {
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Sertifikat berhasil diunggah!',
                                  ),
                                  backgroundColor: Color(0xFF2E7D32),
                                ),
                              );
                              _loadSertifikat();
                            } else {
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Gagal mengunggah sertifikat.'),
                                  backgroundColor: AppColors.danger,
                                ),
                              );
                            }
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
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
                            'Kirim Sertifikat',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 12, color: AppColors.muted),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(SertifikatModel item) {
    final isVerified = item.isVerified;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isVerified ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        item.statusVerifikasi.isNotEmpty
            ? item.statusVerifikasi
            : 'Menunggu Verifikasi',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: isVerified ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Sertifikat Mahasiswa'),
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddModal(context),
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Unggah Sertifikat',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.navy,
        onRefresh: _handleRefresh,
        child: FutureBuilder<List<SertifikatModel>>(
          future: _sertifikatFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.navy),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        size: 48,
                        color: AppColors.muted,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Gagal memuat sertifikat',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Periksa sambungan internet lu dan coba lagi.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _loadSertifikat,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final items = snapshot.data ?? [];
            final verifiedCount = items.where((i) => i.isVerified).length;
            final pendingCount = items.where((i) => i.isPending).length;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              children: [
                _summaryCard(items.length, verifiedCount, pendingCount),
                const SizedBox(height: 20),
                const Text(
                  'Daftar Portofolio Sertifikat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                if (items.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(32),
                    alignment: Alignment.center,
                    child: const Column(
                      children: [
                        Icon(
                          Icons.workspace_premium_outlined,
                          size: 48,
                          color: AppColors.muted,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada sertifikat terunggah',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  for (final item in items) ...[
                    _sertifikatCard(item),
                    const SizedBox(height: 12),
                  ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _summaryCard(int total, int verified, int pending) {
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
            color: AppColors.navy.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Portofolio & Prestasi',
            style: TextStyle(
              color: AppColors.gold,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$total Dokumen Terdaftar',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0x22FFFFFF), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Terverifikasi',
                      style: TextStyle(
                        color: Color(0xFF9FB0C9),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$verified Sertifikat',
                      style: const TextStyle(
                        color: Color(0xFF81C784),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menunggu Verifikasi',
                      style: TextStyle(
                        color: Color(0xFF9FB0C9),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$pending Sertifikat',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sertifikatCard(SertifikatModel item) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _showDetail(context, item),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.goldSoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.tingkat.isNotEmpty ? item.tingkat : 'Nasional',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _statusBadge(item),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                item.nama,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.penyelenggara.isNotEmpty
                    ? item.penyelenggara
                    : 'Penyelenggara Kegiatan',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.nomor.isNotEmpty ? 'No: ${item.nomor}' : '-',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                    ),
                  ),
                  Text(
                    item.formattedDate,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
