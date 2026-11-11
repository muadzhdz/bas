import 'package:flutter/material.dart';

import '../api/bimbingan_api.dart';
import '../models/bimbingan_model.dart';
import '../models/user_model.dart';
import '../theme/app_theme.dart';

class BimbinganScreen extends StatefulWidget {
  final UserModel? user;

  const BimbinganScreen({super.key, this.user});

  @override
  State<BimbinganScreen> createState() => _BimbinganScreenState();
}

class _BimbinganScreenState extends State<BimbinganScreen> {
  final BimbinganApi _bimbinganApi = BimbinganApi();
  late Future<BimbinganModel?> _bimbinganFuture;

  @override
  void initState() {
    super.initState();
    _loadBimbingan();
  }

  void _loadBimbingan() {
    final npm = widget.user?.userid.toString() ?? '12523030';
    setState(() {
      _bimbinganFuture = _bimbinganApi.fetchBimbinganByNpm(npm);
    });
  }

  Future<void> _handleRefresh() async {
    _loadBimbingan();
    await _bimbinganFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text('Bimbingan Skripsi / TA'),
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
      ),
      body: RefreshIndicator(
        color: AppColors.navy,
        onRefresh: _handleRefresh,
        child: FutureBuilder<BimbinganModel?>(
          future: _bimbinganFuture,
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
                        'Gagal memuat data bimbingan',
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
                        onPressed: _loadBimbingan,
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final data = snapshot.data;
            if (data == null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.school_outlined,
                        size: 48,
                        color: AppColors.muted,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Data Bimbingan Belum Tersedia',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Lu belum terdaftar dalam periode bimbingan proposal atau tugas akhir aktif.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.muted),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: _loadBimbingan,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _headerCard(data),
                const SizedBox(height: 16),
                _permasalahanCard(data.permasalahan),
                const SizedBox(height: 16),
                _statusMilestoneSection(data),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _headerCard(BimbinganModel data) {
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  data.topik.isNotEmpty ? data.topik : 'Tugas Akhir',
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'TA ${data.tahunAkademik}',
                style: const TextStyle(
                  color: Color(0xFF9FB0C9),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            data.judul,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0x22FFFFFF), height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.person_pin_outlined,
                size: 16,
                color: AppColors.gold,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dosen Pembimbing (NIP: ${data.nipDosen})',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.date_range_outlined,
                size: 16,
                color: Color(0xFF9FB0C9),
              ),
              const SizedBox(width: 8),
              Text(
                'Periode: ${data.tanggalMulai} s.d ${data.tanggalSelesai}',
                style: const TextStyle(
                  color: Color(0xFF9FB0C9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _permasalahanCard(String permasalahan) {
    if (permasalahan.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 18,
                color: AppColors.gold,
              ),
              SizedBox(width: 8),
              Text(
                'Latar Belakang / Permasalahan',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            permasalahan,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusMilestoneSection(BimbinganModel data) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tahapan Bimbingan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          _stepTile(
            number: '1',
            title: 'Proposal Tugas Akhir',
            skNumber: data.skProposal,
            isApproved: data.isProposalApproved,
            statusText: data.isProposalApproved
                ? 'Disetujui'
                : 'Menunggu Verifikasi',
          ),
          const Padding(
            padding: EdgeInsets.only(left: 17),
            child: SizedBox(
              height: 24,
              child: VerticalDivider(color: AppColors.border, thickness: 2),
            ),
          ),
          _stepTile(
            number: '2',
            title: 'Laporan Tugas Akhir / Skripsi',
            skNumber: data.skTugasAkhir,
            isApproved: data.isTugasAkhirCompleted,
            statusText: data.isTugasAkhirCompleted
                ? 'Lulus / Selesai'
                : 'Proses Bimbingan Aktif',
          ),
        ],
      ),
    );
  }

  Widget _stepTile({
    required String number,
    required String title,
    required String skNumber,
    required bool isApproved,
    required String statusText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isApproved ? const Color(0xFFE8F5E9) : AppColors.goldSoft,
            shape: BoxShape.circle,
            border: Border.all(
              color: isApproved ? const Color(0xFF2E7D32) : AppColors.gold,
              width: 1.5,
            ),
          ),
          child: Center(
            child: isApproved
                ? const Icon(Icons.check, size: 20, color: Color(0xFF2E7D32))
                : Text(
                    number,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy,
                      fontSize: 14,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              if (skNumber.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'No. SK: $skNumber',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.muted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isApproved
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: isApproved
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
