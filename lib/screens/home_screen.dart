import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'dhs_screen.dart';
import 'khs_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(String title) onOpenMenu;
  final UserModel? user;
  final bool showWelcomeAlert;

  const HomeScreen({
    super.key,
    required this.onOpenMenu,
    this.user,
    this.showWelcomeAlert = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showWelcome = false;

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
  void initState() {
    super.initState();
    if (widget.showWelcomeAlert) {
      _showWelcome = true;
      // Auto-dismiss setelah 2.5 detik
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() {
            _showWelcome = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          // Alert Selamat Datang (Muncul 2-3 detik saat baru login)
          if (_showWelcome) ...[
            AnimatedOpacity(
              opacity: _showWelcome ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 350),
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF15803D),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF15803D).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Selamat datang, ${widget.user?.nama ?? "Sofi Arianti"}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

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
              if (widget.user != null)
                Text(
                  'Status: ${widget.user!.isStatusAktif ? "Aktif" : "Nonaktif"}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: widget.user!.isStatusAktif ? Colors.green[700] : Colors.red[700],
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
    final displayName = widget.user?.nama.isNotEmpty == true ? widget.user!.nama : "Mu'adz Hudzaifah";
    final displayNpm = widget.user != null ? 'NPM ${widget.user!.userid}' : 'NPM 24903460014';

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
    bool isEnabled = true;
    String? disabledReason;

    if (label == 'KRS') {
      isEnabled = widget.user?.isKrsAktif ?? true;
      if (!isEnabled) {
        disabledReason = 'Menu KRS sedang dinonaktifkan (bperwalian = 0)';
      }
    } else if (label == 'Presensi') {
      isEnabled = widget.user?.isAbsenAktif ?? true;
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
          } else if (label == 'KHS') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KhsScreen(user: widget.user),
              ),
            );
          } else if (label == 'DHS') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DhsScreen(user: widget.user),
              ),
            );
          } else {
            widget.onOpenMenu(label);
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
