# Boash Academic System (BAS)

Portal akademik mobile mahasiswa berbasis Flutter yang terintegrasi dengan layanan akademik kampus, autentikasi sesi, dan pemindai presensi perkuliahan.

## Modul Sistem

- Autentikasi: Login mahasiswa berbasis verifikasi hash SHA-1 dan validasi status akademik aktif.
- Beranda & Navigasi: Rangkuman identitas mahasiswa, kalender akademik, dan navigasi utama.
- Berita & Informasi: Pengumuman kegiatan perkuliahan dan administrasi kampus.
- Akademik: Pengelolaan Kartu Rencana Studi (KRS), Kartu Hasil Studi (KHS), dan Daftar Hasil Studi (DHS).
- Layanan Mahasiswa: Informasi status pembayaran (Finance), log bimbingan akademik, dan repositori sertifikat prestasi.
- Presensi Perkuliahan: Pemindaian barcode/QR code presensi secara real-time via kamera perangkat.
- Profil: Rincian data mahasiswa dan ekspor dokumen KTM digital.

## Persyaratan Lingkungan

- Flutter SDK ^3.13.0
- Dart SDK ^3.1.0
- Java OpenJDK 17
- Android SDK (API 34 / Android 14+)

## Menjalankan Proyek

1. Clone repositori:
   ```bash
   git clone https://github.com/muadzhdz/bas.git
   cd bas
   ```

2. Pasang dependensi:
   ```bash
   flutter pub get
   ```

3. Jalankan pengujian:
   ```bash
   flutter test
   ```

4. Jalankan aplikasi:
   ```bash
   flutter run
   ```
