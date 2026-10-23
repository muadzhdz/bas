import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final void Function(String title) onOpenMenu;
  final UserModel? user;

  const HomeScreen({
    super.key,
    required this.onOpenMenu,
    this.user,
  });

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu Akademik',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              if (user != null)
                Text(
                  'Status: ${user!.isStatusAktif ? "Aktif" : "Nonaktif"}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: user!.isStatusAktif ? Colors.green[700] : Colors.red[700],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.88,
            children: [
              for (final menu in _menus) _menuTile(context, menu.$1, menu.$2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _greetingCard() {
    final displayName = user?.nama.isNotEmpty == true ? user!.nama : "Mu'adz Hudzaifah";
    final displayNpm = user != null ? 'NPM ${user!.userid}' : 'NPM 24903460014';

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
              children: [
                const Text(
                  'Selamat datang,',
                  style: TextStyle(color: Color(0xFF9FB0C9), fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  displayName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  displayNpm,
                  style: const TextStyle(color: AppColors.gold, fontSize: 13),
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

  Widget _menuTile(BuildContext context, IconData icon, String label) {
    // Kriteria:
    // KRS aktif jika bperwalian == 1, nonaktif/disable jika 0
    // Presensi (Absen) aktif jika babsen == 1, nonaktif/disable jika 0
    bool isEnabled = true;
    String? disabledReason;

    if (label == 'KRS') {
      isEnabled = user?.isKrsAktif ?? true;
      if (!isEnabled) {
        disabledReason = 'Menu KRS sedang dinonaktifkan (bperwalian = 0)';
      }
    } else if (label == 'Presensi') {
      isEnabled = user?.isAbsenAktif ?? true;
      if (!isEnabled) {
        disabledReason = 'Menu Presensi sedang dinonaktifkan (babsen = 0)';
      }
    }

    return Material(
      color: isEnabled ? AppColors.white : const Color(0xFFF1F3F5),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (!isEnabled) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(disabledReason ?? 'Menu sedang dinonaktifkan'),
                  duration: const Duration(milliseconds: 1600),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.danger,
                ),
              );
          } else {
            onOpenMenu(label);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isEnabled ? AppColors.border : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isEnabled ? AppColors.goldSoft : const Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isEnabled ? AppColors.navy : const Color(0xFF94A3B8),
                  size: 22,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isEnabled ? AppColors.ink : const Color(0xFF94A3B8),
                ),
              ),
              if (!isEnabled) ...[
                const SizedBox(height: 2),
                const Text(
                  'Nonaktif (0)',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: AppColors.danger,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
