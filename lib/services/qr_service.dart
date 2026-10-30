class QrService {
  /// Memvalidasi kode QR presensi perkuliahan
  bool validateQr(String code) {
    return code.trim() == "ABSEN-TRM-2026";
  }
}
