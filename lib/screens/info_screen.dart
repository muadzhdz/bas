import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  static const List<(String, String, String)> _posts = [
    (
      'Jadwal UAS Semester Ganjil',
      'UAS dilaksanakan 12-20 Januari 2027. Cek jadwal per mata kuliah di KRS kamu.',
      'Akademik',
    ),
    (
      'Pengisian KRS Online',
      'Pengisian KRS dibuka mulai 3 Februari 2027 melalui portal akademik.',
      'Registrasi',
    ),
    (
      'Beasiswa Prestasi Boash',
      'Pendaftaran beasiswa prestasi dibuka hingga akhir bulan ini untuk semester genap.',
      'Kemahasiswaan',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info Kampus')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        itemCount: _posts.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final post = _posts[index];
          return _InfoCard(title: post.$1, body: post.$2, tag: post.$3);
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;
  final String tag;

  const _InfoCard({required this.title, required this.body, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.goldSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.navy,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}
