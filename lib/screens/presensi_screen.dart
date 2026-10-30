import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

  bool _isProcessing = false;
  bool _isTorchOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    final isValid = _qrService.validateQr(code);
    final displayName = widget.user?.nama.isNotEmpty == true
        ? widget.user!.nama
        : "Mu'adz Hudzaifah";
    final displayNpm = widget.user != null
        ? widget.user!.userid.toString()
        : '24903460014';

    if (isValid) {
      await SweetAlert.success(
        context: context,
        title: 'Presensi Berhasil!',
        message: 'Status: HADIR\n$displayName (NPM: $displayNpm)\nKode: $code',
        autoCloseDuration: const Duration(milliseconds: 2200),
      );
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
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
    final displayName = widget.user?.nama.isNotEmpty == true
        ? widget.user!.nama
        : "Mu'adz Hudzaifah";
    final displayNpm = widget.user != null
        ? 'NPM ${widget.user!.userid}'
        : 'NPM 24903460014';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Presensi QR'),
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
      ),
      body: Stack(
        children: [
          // Viewfinder MobileScanner
          MobileScanner(controller: _controller, onDetect: _onDetect),

          // Overlay Bingkai Bidik Scanner
          _buildScannerOverlay(),

          // Kartu Identitas Mahasiswa di Bagian Atas
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.4),
                ),
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

          // Petunjuk Arahkan Kamera di Bagian Bawah
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
