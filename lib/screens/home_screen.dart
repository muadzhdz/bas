import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final void Function(String title) onOpenMenu;

  const HomeScreen({super.key, required this.onOpenMenu});

  static const List<(IconData, String)> _menus = [
    (Icons.assignment_outlined, 'KRS'),
    (Icons.grade_outlined, 'DHS'),
    (Icons.fact_check_outlined, 'KHS'),
    (Icons.account_balance_wallet_outlined, 'Finance'),
    (Icons.support_agent_outlined, 'Bimbingan'),
    (Icons.workspace_premium_outlined, 'Sertifikat'),
    (Icons.menu_book_outlined, 'Materi'),
    (Icons.checklist_rounded, 'Tugas'),
    (Icons.how_to_reg_outlined, 'Presensi'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _greetingCard(),
          const SizedBox(height: 22),
          const Text(
            'Menu Akademik',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.92,
            children: [
              for (final menu in _menus) _menuTile(menu.$1, menu.$2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _greetingCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navyDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Selamat datang,',
                  style: TextStyle(color: Color(0xFF9FB0C9), fontSize: 13),
                ),
                SizedBox(height: 4),
                Text(
                  "Mu'adz Hudzaifah",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'NPM 24903460014',
                  style: TextStyle(color: AppColors.gold, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.school_rounded, color: AppColors.gold, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String label) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onOpenMenu(label),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.goldSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.navy, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
