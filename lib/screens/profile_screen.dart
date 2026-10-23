import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final UserModel? user;

  const ProfileScreen({
    super.key,
    required this.onLogout,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        children: [
          _identityCard(),
          const SizedBox(height: 16),
          _ktmCard(context),
          const SizedBox(height: 16),
          _detailsCard(),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: onLogout,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Keluar'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _identityCard() {
    final displayName = user?.nama.isNotEmpty == true ? user!.nama : "Mu'adz Hudzaifah";
    final displayNpm = user != null ? 'NPM ${user!.userid}' : 'NPM 24903460014';
    final roleText = user != null
        ? (user!.isRoleMahasiswa ? 'Mahasiswa (Role 14)' : 'Role ${user!.roleid}')
        : 'Teknologi Rekayasa Multimedia';

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
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.asset(
              'assets/images/mentor-profile.jpg',
              width: 64,
              height: 64,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  displayNpm,
                  style: const TextStyle(color: AppColors.gold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  roleText,
                  style: const TextStyle(color: Color(0xFF9FB0C9), fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ktmCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.credit_card_rounded, color: AppColors.navy),
              SizedBox(width: 10),
              Text(
                'Kartu Tanda Mahasiswa',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Unduh KTM digital kamu dalam format PDF.',
            style: TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('KTM sedang diunduh (dummy)...'),
                    duration: Duration(milliseconds: 1200),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
            },
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download KTM'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.navyDark,
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsCard() {
    final email = user != null ? '${user!.userid}@boash.ac.id' : 'muadzhdz@boash.ac.id';
    final statusAkun = (user?.isStatusAktif ?? true) ? 'Aktif (1)' : 'Disable (0)';
    final statusKrs = (user?.isKrsAktif ?? true) ? 'Aktif (1)' : 'Disable (0)';
    final statusAbsen = (user?.isAbsenAktif ?? true) ? 'Aktif (1)' : 'Disable (0)';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _DetailRow(icon: Icons.email_outlined, label: 'Email', value: email),
          const _DetailRow(icon: Icons.phone_outlined, label: 'Telepon', value: '085694718914'),
          const _DetailRow(icon: Icons.calendar_today_outlined, label: 'Angkatan', value: '2024'),
          _DetailRow(icon: Icons.badge_outlined, label: 'Status Akun', value: statusAkun),
          _DetailRow(icon: Icons.assignment_outlined, label: 'Status KRS', value: statusKrs),
          _DetailRow(icon: Icons.how_to_reg_outlined, label: 'Status Absen', value: statusAbsen),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.navy),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
