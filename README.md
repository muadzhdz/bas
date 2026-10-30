# Boash Academic System (BAS)

Aplikasi portal akademik mahasiswa berbasis Flutter dengan antarmuka modern, sistem autentikasi terintegrasi, pemindaian QR Code presensi perkuliahan, dan penyimpanan sesi lokal.

## Fitur Utama

- Autentikasi Mahasiswa: Integrasi login dengan verifikasi kredensial NPM dan kata sandi.
- Sesi Persisten (Auto-Login): Sesi pengguna tersimpan di penyimpanan lokal perangkat sehingga tidak perlu login berulang saat aplikasi dibuka kembali.
- Presensi QR Code: Pemindai kode QR realtime menggunakan mobile_scanner dengan validasi sesi presensi perkuliahan.
- Manajemen Akademik: Akses informasi akademik mahasiswa meliputi KRS, KHS, dan DHS.
- Desain Antarmuka: Mengadopsi palet warna Navy dan Gold yang konsisten dan responsif.

## Tech Stack

- Framework: Flutter (SDK ^3.13.0)
- Bahasa: Dart
- State & Storage: SharedPreferences (Session Management)
- Kamera & Pemindai: MobileScanner
- Komunikasi Data: HTTP Client, Crypto (SHA-1)

## Menjalankan Aplikasi

1. Clone repositori:
   ```bash
   git clone https://github.com/muadzhdz/bas.git
   cd bas
   ```

2. Unduh dependensi:
   ```bash
   flutter pub get
   ```

3. Jalankan aplikasi pada perangkat Android atau emulator:
   ```bash
   flutter run -d <device-id>
   ```

4. Bangun APK rilis:
   ```bash
   flutter build apk --release
   ```

## Lisensi

Proyek ini dikembangkan untuk kebutuhan internal akademik Boash Academic System.
