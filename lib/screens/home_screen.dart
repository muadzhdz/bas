import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'dhs_screen.dart';
import 'khs_screen.dart';
import 'krs_screen.dart';
import 'presensi_screen.dart';

class HomeScreen extends StatelessWidget {
  final void Function(String title) onOpenMenu;
  final UserModel? user;

  const HomeScreen({super.key, required this.onOpenMenu, this.user});

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
      backgroundColor: AppColors.white,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          // Kartu Identitas Mahasiswa (Tanpa teks selamat datang, dengan foto mentor)
          _studentIdentityCard(),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu Akademik',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.ink,
                ),
              ),
              if (user != null)
                Text(
                  'Status: ${user!.isStatusAktif ? "Aktif" : "Nonaktif"}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: user!.isStatusAktif
                        ? Colors.green[700]
                        : Colors.red[700],
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

  Widget _studentIdentityCard() {
    final displayName = user?.nama.isNotEmpty == true
        ? user!.nama
        : "Mu'adz Hudzaifah";
    final displayNpm = user != null ? 'NPM ${user!.userid}' : 'NPM 24903460014';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.navy, AppColors.navyDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'TEKNOLOGI REKAYASA MULTIMEDIA',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  displayName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  displayNpm,
                  style: const TextStyle(
                    color: Color(0xFF9FB0C9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Foto Mahasiswa (Foto Mentor)
          Container(
            padding: const EdgeInsets.all(2.5),
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/mentor-profile.jpg',
                width: 58,
                height: 58,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile(BuildContext context, IconData icon, String label) {
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
          } else if (label == 'KRS') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KrsScreen(user: user)),
            );
          } else if (label == 'KHS') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => KhsScreen(user: user)),
            );
          } else if (label == 'DHS') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DhsScreen(user: user)),
            );
          } else if (label == 'Presensi') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PresensiScreen(user: user),
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
                  color: isEnabled
                      ? AppColors.goldSoft
                      : const Color(0xFFE2E8F0),
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
                  fontWeight: FontWeight.w700,
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
