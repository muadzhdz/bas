import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../theme/app_theme.dart';

class KrsScreen extends StatelessWidget {
  final UserModel? user;

  const KrsScreen({super.key, this.user});

  static const List<(String, String, int, String, String)> _krsCourses = [
    ('GC330', 'Pemrograman Berorientasi Objek', 3, 'LU0512', 'Senin, 08:00 - 10:30 (R. Lab 1)'),
    ('GC331', 'Animasi & Pemodelan 3D', 3, 'AT2047', 'Selasa, 10:00 - 12:30 (R. Lab Studio)'),
    ('GC332', 'Rekayasa Multimedia Terapan', 3, 'RM0311', 'Rabu, 13:00 - 15:30 (R. 302)'),
    ('GC333', 'Jaringan Komputer & Cloud', 3, 'NW0124', 'Kamis, 08:00 - 10:30 (R. Lab Net)'),
    ('GC334', 'Desain Pengalaman Pengguna (UI/UX)', 3, 'UX0981', 'Jumat, 09:00 - 11:30 (R. 204)'),
    ('GC335', 'Pemrograman Web Lanjut', 3, 'WB0452', 'Kamis, 13:30 - 16:00 (R. Lab 2)'),
    ('GC336', 'Etika Profesi & Komunikasi', 2, 'ET0219', 'Rabu, 10:00 - 11:40 (R. 101)'),
  ];

  @override
  Widget build(BuildContext context) {
    final studentName = user?.nama.isNotEmpty == true ? user!.nama : 'Sofi Arianti';
    final studentNpm = user != null ? user!.userid.toString() : '12523030';
    final totalSks = _krsCourses.fold(0, (sum, item) => sum + item.$3);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
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
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Status Perwalian Card
          _buildKrsHeader(studentName, studentNpm, totalSks),
          const SizedBox(height: 20),

          // Title & Total Mata Kuliah
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_krsCourses.length} Matkul • $totalSks SKS',
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

          // List Mata Kuliah KRS
          for (final course in _krsCourses) _buildCourseCard(course),

          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('KRS Semester Genap berhasil diunduh (PDF).'),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF16A34A).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF4ADE80)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.verified_rounded, color: Color(0xFF4ADE80), size: 14),
                    SizedBox(width: 6),
                    Text(
                      'Disetujui Dosen Wali',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4ADE80),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Semester 2 (Genap)',
                style: TextStyle(
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
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9FB0C9),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF1E3A5F)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricColumn('Beban SKS', '$totalSks / 24 SKS'),
              _buildMetricColumn('T.A.', '2023/2024'),
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

  Widget _buildCourseCard((String, String, int, String, String) course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              course.$1,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.$2,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded, size: 13, color: AppColors.muted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        course.$5,
                        style: const TextStyle(fontSize: 11, color: AppColors.muted),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Dosen: ${course.$4}',
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
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
              '${course.$3} SKS',
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
}
