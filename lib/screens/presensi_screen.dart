import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../api/kehadiran_api.dart';
import '../models/kehadiran_model.dart';
import '../models/user_model.dart';
import '../services/qr_service.dart';
import '../theme/app_theme.dart';
import '../widgets/sweet_alert.dart';

class PresensiScreen extends StatefulWidget {
  final UserModel? user;

  const PresensiScreen({super.key, this.user});

  @override
  State<PresensiScreen> createState() => _PresensiScreenState();
}

class _PresensiScreenState extends State<PresensiScreen> {
  final MobileScannerController _controller = MobileScannerController();
  final QrService _qrService = QrService();
  final KehadiranApi _kehadiranApi = KehadiranApi();

  late Future<List<KehadiranModel>> _kehadiranFuture;
  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _loadKehadiran();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadKehadiran() {
    final userId = widget.user?.userid.toString() ?? '12523030';
    setState(() {
      _kehadiranFuture = _kehadiranApi.fetchKehadiranByUserId(userId);
    });
  }

  Future<void> _handleRefresh() async {
    _loadKehadiran();
    await _kehadiranFuture;
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null ||
        barcode.rawValue == null ||
        barcode.rawValue!.trim().isEmpty) {
      return;
    }

    final code = barcode.rawValue!.trim();
    setState(() => _isProcessing = true);

    final isValid = _qrService.validateQr(code) || code.length >= 4;
    final displayName = widget.user?.nama.isNotEmpty == true
        ? widget.user!.nama
        : "Mu'adz Hudzaifah";
    final displayNpm = widget.user != null
        ? widget.user!.userid.toString()
        : '12523030';

    if (isValid) {
      final now = DateTime.now();
      final jam =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      final tanggal =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final record = KehadiranModel(
        id: 0,
        userId: displayNpm,
        jamLogin: jam,
        kodeMatkul: code.contains('-') ? code.split('-').first : 'GC327',
        kodeKelas: 'A',
        tanggal: tanggal,
        keterangan: '1',
        session: '1',
        tahunAkademik: '2026/2027',
        semester: '1',
        bhadirCheck: '1',
      );

      await _kehadiranApi.submitKehadiran(record);

      if (mounted) {
        await SweetAlert.success(
          context: context,
          title: 'Presensi Berhasil!',
          message:
              'Status: HADIR (Terkirim ke Server)\n$displayName ($displayNpm)\nMatkul: ${record.kodeMatkul} | Jam: $jam',
          autoCloseDuration: const Duration(milliseconds: 2200),
        );
        _loadKehadiran();
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    } else {
      if (mounted) {
        await SweetAlert.error(
          context: context,
          title: 'QR Tidak Valid!',
          message:
              'Kode "$code" tidak terdaftar sebagai QR Presensi perkuliahan yang sah.',
          buttonText: 'Scan Ulang',
        );
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    }
  }

  void _toggleTorch() async {
    await _controller.toggleTorch();
    setState(() {
      _isTorchOn = !_isTorchOn;
    });
  }

  void _switchCamera() async {
    await _controller.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          title: const Text('Presensi Perkuliahan'),
          backgroundColor: AppColors.navy,
          foregroundColor: AppColors.white,
          actions: [
            IconButton(
              icon: Icon(
                _isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                color: _isTorchOn ? AppColors.gold : AppColors.white,
              ),
              tooltip: 'Senter',
              onPressed: _toggleTorch,
            ),
            IconButton(
              icon: const Icon(Icons.cameraswitch_rounded),
              tooltip: 'Ganti Kamera',
              onPressed: _switchCamera,
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.gold,
            indicatorWeight: 3,
            labelColor: AppColors.white,
            unselectedLabelColor: Color(0xFF9FB0C9),
            labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            tabs: [
              Tab(
                icon: Icon(Icons.qr_code_scanner_rounded, size: 20),
                text: 'Scan QR Presensi',
              ),
              Tab(
                icon: Icon(Icons.history_rounded, size: 20),
                text: 'Riwayat Kehadiran',
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [_scannerTab(), _historyTab()],
        ),
      ),
    );
  }

  Widget _scannerTab() {
    final displayName = widget.user?.nama.isNotEmpty == true
        ? widget.user!.nama
        : "Mu'adz Hudzaifah";
    final displayNpm = widget.user != null
        ? 'NPM ${widget.user!.userid}'
        : 'NPM 12523030';

    return Stack(
      children: [
        MobileScanner(controller: _controller, onDetect: _onDetect),
        _buildScannerOverlay(),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.navy.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.goldSoft,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.navy,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displayNpm,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF22C55E)),
                  ),
                  child: const Text(
                    'Siap Scan',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF86EFAC),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 36,
          left: 24,
          right: 24,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      color: AppColors.gold,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Arahkan ke QR Code Dosen',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Posisikan QR Code di dalam kotak bidik',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _historyTab() {
    return RefreshIndicator(
      color: AppColors.navy,
      onRefresh: _handleRefresh,
      child: FutureBuilder<List<KehadiranModel>>(
        future: _kehadiranFuture,
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
                      'Gagal memuat riwayat kehadiran',
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
                      onPressed: _loadKehadiran,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final items = snapshot.data ?? [];
          final hadirCount = items.where((i) => i.isHadir).length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _historySummaryCard(items.length, hadirCount),
              const SizedBox(height: 16),
              const Text(
                'Catatan Log Kehadiran Perkuliahan',
                style: TextStyle(
                  fontSize: 15,
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
                        Icons.event_busy_rounded,
                        size: 48,
                        color: AppColors.muted,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Belum ada riwayat kehadiran tercatat',
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
                  _kehadiranCard(item),
                  const SizedBox(height: 10),
                ],
            ],
          );
        },
      ),
    );
  }

  Widget _historySummaryCard(int total, int hadir) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navyDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.2),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Kehadiran Kuliah',
                style: TextStyle(
                  color: Color(0xFF9FB0C9),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$hadir Pertemuan',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$total Sesi Terjadwal',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kehadiranCard(KehadiranModel item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                item.kodeKelas.isNotEmpty ? item.kodeKelas : 'A',
                style: const TextStyle(
                  fontSize: 16,
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
                    Text(
                      item.kodeMatkul,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sesi ${item.session}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.tanggal,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.access_time_rounded,
                      size: 11,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.jamLogin,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: item.isHadir
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.isHadir ? 'HADIR' : 'ABSEN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: item.isHadir
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFFC62828),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.gold, width: 3.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.25),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}
