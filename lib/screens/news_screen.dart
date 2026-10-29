import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  static const List<(String, String, String)> _news = [
    (
      'Boash Raih Akreditasi Unggul',
      'Sistem penjaminan mutu kampus Boash resmi meraih predikat akreditasi unggul.',
      'Internal',
    ),
    (
      'Kerja Sama Industri Teknologi',
      'Boash menandatangani MoU dengan beberapa perusahaan teknologi nasional.',
      'Internal',
    ),
    (
      'Kemajuan Riset AI Nasional',
      'Pemerintah mendorong riset kecerdasan buatan di kampus-kampus Indonesia.',
      'Eksternal',
    ),
    (
      'Kompetisi Inovasi Mahasiswa',
      'Kompetisi inovasi tingkat nasional dibuka untuk seluruh mahasiswa Indonesia.',
      'Eksternal',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        itemCount: _news.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _news[index];
          return _NewsCard(
            title: item.$1,
            body: item.$2,
            scope: item.$3,
          );
        },
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  final String title;
  final String body;
  final String scope;

  const _NewsCard({
    required this.title,
    required this.body,
    required this.scope,
  });

  @override
  Widget build(BuildContext context) {
    final bool isInternal = scope == 'Internal';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isInternal ? AppColors.navy : AppColors.gold,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isInternal ? Icons.campaign_outlined : Icons.public_rounded,
              color: isInternal ? AppColors.white : AppColors.navyDark,
              size: 22,
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
                      scope,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Berita Kampus',
                      style: TextStyle(fontSize: 11, color: AppColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
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
          ),
        ],
      ),
    );
  }
}
