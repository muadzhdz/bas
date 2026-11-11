import 'package:flutter/material.dart';

import '../api/mahasiswa_api.dart';
import '../models/mahasiswa_model.dart';
import '../models/user_model.dart';
import '../services/session_service.dart';
import '../theme/app_theme.dart';
import '../widgets/gender_avatar.dart';
import '../widgets/sweet_alert.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final UserModel? user;

  const ProfileScreen({super.key, required this.onLogout, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final MahasiswaApi _mahasiswaApi = MahasiswaApi();
  MahasiswaModel? _mahasiswa;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final cached = await SessionService.getMahasiswa();
    if (mounted && cached != null) {
      setState(() {
        _mahasiswa = cached;
        _isLoading = false;
      });
    }

    final npm = widget.user?.userid.toString() ?? '12523030';
    try {
      final fresh = await _mahasiswaApi.fetchMahasiswaByNpm(npm);
      if (mounted) {
        if (fresh != null) {
          await SessionService.saveMahasiswa(fresh);
          setState(() {
            _mahasiswa = fresh;
            _isLoading = false;
            _errorMessage = null;
          });
        } else if (_mahasiswa == null) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Data profil mahasiswa tidak ditemukan.';
          });
        }
      }
    } catch (_) {
      if (mounted && _mahasiswa == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat profil mahasiswa.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: RefreshIndicator(
        color: AppColors.navy,
        onRefresh: _loadProfile,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            if (_errorMessage != null && _mahasiswa == null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFCA5A5)),
                ),
                child: Column(
                  children: [
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _loadProfile,
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_isLoading && _mahasiswa == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: CircularProgressIndicator(color: AppColors.navy),
                ),
              )
            else ...[
              _identityCard(),
              const SizedBox(height: 16),
              _ktmCard(context),
              const SizedBox(height: 16),
              _academicDetailsCard(),
              const SizedBox(height: 16),
              _personalDetailsCard(),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  final confirmed = await SweetAlert.confirm(
                    context: context,
                    title: 'Konfirmasi Keluar',
                    message: 'Apakah Anda yakin ingin keluar dari Portal Akademik Boash?',
                    confirmText: 'Ya, Keluar',
                    cancelText: 'Batal',
                  );
                  if (confirmed == true) {
                    widget.onLogout();
                  }
                },
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
          ],
        ),
      ),
    );
  }

  Widget _identityCard() {
    final displayName = _mahasiswa?.nama.isNotEmpty == true
        ? _mahasiswa!.nama
        : (widget.user?.nama.isNotEmpty == true
              ? widget.user!.nama
              : 'Sofi Arianti');
    final displayNpm = _mahasiswa != null
        ? 'NPM ${_mahasiswa!.npm}'
        : (widget.user != null ? 'NPM ${widget.user!.userid}' : 'NPM 12523030');
    final prodi = _mahasiswa?.namaProdi ?? 'Teknologi Rekayasa Multimedia';
    final jenjang = _mahasiswa?.jenjangFormatted ?? 'D4 / Sarjana Terapan';
    final isFemale = _mahasiswa?.isPerempuan ?? true;
    final isAktif = _mahasiswa?.isAktif ?? (widget.user?.isStatusAktif ?? true);

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
            color: AppColors.navy.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              GenderAvatar(isFemale: isFemale, size: 68),
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
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayNpm,
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '$prodi • $jenjang',
                      style: const TextStyle(
                        color: Color(0xFF9FB0C9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderBadge(
                  icon: isAktif
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  iconColor: isAktif
                      ? const Color(0xFF10B981)
                      : AppColors.danger,
                  label: isAktif ? 'Mahasiswa Aktif' : 'Nonaktif',
                ),
                Container(
                  width: 1,
                  height: 18,
                  color: AppColors.white.withValues(alpha: 0.2),
                ),
                _buildHeaderBadge(
                  icon: isFemale ? Icons.female_rounded : Icons.male_rounded,
                  iconColor: isFemale
                      ? const Color(0xFFF472B6)
                      : const Color(0xFF60A5FA),
                  label: isFemale ? 'Perempuan' : 'Laki-laki',
                ),
                Container(
                  width: 1,
                  height: 18,
                  color: AppColors.white.withValues(alpha: 0.2),
                ),
                _buildHeaderBadge(
                  icon: Icons.meeting_room_outlined,
                  iconColor: AppColors.gold,
                  label: 'Kelas ${_mahasiswa?.kdKelas ?? "A"}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBadge({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _ktmCard(BuildContext context) {
    final displayName = _mahasiswa?.nama.isNotEmpty == true
        ? _mahasiswa!.nama
        : (widget.user?.nama.isNotEmpty == true
              ? widget.user!.nama
              : 'Sofi Arianti');
    final displayNpm = _mahasiswa?.npm.isNotEmpty == true
        ? _mahasiswa!.npm
        : (widget.user?.userid ?? '12523030');
    final prodi = _mahasiswa?.namaProdi ?? 'Teknologi Rekayasa Multimedia';
    final angkatan = _mahasiswa?.tahunMasuk ?? '2023/2024';
    final isFemale = _mahasiswa?.isPerempuan ?? true;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.vertical(top: Radius.circular(17)),
            ),
            child: Row(
              children: const [
                Icon(Icons.badge_rounded, color: AppColors.gold, size: 20),
                SizedBox(width: 8),
                Text(
                  'KARTU TANDA MAHASISWA DIGITAL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GenderAvatar(isFemale: isFemale, size: 54),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'NPM: $displayNpm',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            prodi,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.muted,
                            ),
                          ),
                          Text(
                            'Tahun Masuk: $angkatan',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.qr_code_rounded,
                        size: 40,
                        color: AppColors.navy,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            'KTM Digital ($displayNpm) berhasil disimpan ke dokumen.',
                          ),
                          duration: const Duration(milliseconds: 1600),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                  },
                  icon: const Icon(Icons.download_rounded, size: 18),
                  label: const Text('Download KTM Digital'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.navyDark,
                    minimumSize: const Size.fromHeight(44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _academicDetailsCard() {
    final prodi = _mahasiswa?.namaProdi ?? 'Teknologi Rekayasa Multimedia';
    final jenjang = _mahasiswa?.jenjangFormatted ?? 'D4 / Sarjana Terapan';
    final kelas = _mahasiswa?.kdKelas.isNotEmpty == true
        ? 'Kelas ${_mahasiswa!.kdKelas}'
        : 'Kelas A';
    final angkatan = _mahasiswa?.tahunMasuk ?? '2023/2024';
    final statusAkademik = _mahasiswa?.statusMahasiswaLabel ?? 'Aktif';
    final statusKrs = (widget.user?.isKrsAktif ?? true)
        ? 'Diizinkan (Aktif)'
        : 'Dibatasi (0)';
    final statusAbsen = (widget.user?.isAbsenAktif ?? true)
        ? 'Diizinkan (Aktif)'
        : 'Dibatasi (0)';
    final statusUjian = (widget.user?.isUjianAktif ?? true)
        ? 'Diizinkan (Aktif)'
        : 'Dibatasi (0)';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.school_outlined, size: 20, color: AppColors.navy),
              SizedBox(width: 8),
              Text(
                'Informasi Akademik',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.account_balance_outlined,
            label: 'Program Studi',
            value: prodi,
          ),
          _DetailRow(
            icon: Icons.history_edu_outlined,
            label: 'Jenjang Pendidikan',
            value: jenjang,
          ),
          _DetailRow(
            icon: Icons.meeting_room_outlined,
            label: 'Kelas',
            value: kelas,
          ),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'Tahun Masuk / Angkatan',
            value: angkatan,
          ),
          _DetailRow(
            icon: Icons.verified_user_outlined,
            label: 'Status Mahasiswa',
            value: statusAkademik,
          ),
          _DetailRow(
            icon: Icons.assignment_outlined,
            label: 'Hak Akses KRS',
            value: statusKrs,
          ),
          _DetailRow(
            icon: Icons.how_to_reg_outlined,
            label: 'Hak Akses Presensi',
            value: statusAbsen,
          ),
          _DetailRow(
            icon: Icons.description_outlined,
            label: 'Hak Akses Ujian',
            value: statusUjian,
          ),
        ],
      ),
    );
  }

  Widget _personalDetailsCard() {
    final gender = _mahasiswa?.jenisKelaminFormatted ?? 'Perempuan';
    final ttl = _mahasiswa?.ttlFormatted ?? '-';
    final agama = _mahasiswa?.agama.isNotEmpty == true
        ? _mahasiswa!.agama
        : 'Islam';
    final warganegara = _mahasiswa?.wargaNegara.isNotEmpty == true
        ? _mahasiswa!.wargaNegara
        : 'Indonesia';
    final statusNikah = _mahasiswa?.perkawinan.isNotEmpty == true
        ? _mahasiswa!.perkawinan
        : 'Belum Menikah';
    final email = _mahasiswa?.email.isNotEmpty == true
        ? _mahasiswa!.email
        : '${_mahasiswa?.npm ?? widget.user?.userid ?? "12523030"}@boash.ac.id';
    final hp = _mahasiswa?.handphone.isNotEmpty == true
        ? _mahasiswa!.handphone
        : '-';
    final telp = _mahasiswa?.tlpRumah.isNotEmpty == true
        ? _mahasiswa!.tlpRumah
        : '-';
    final alamat = _mahasiswa?.alamatLengkap ?? '-';
    final sekolah = _mahasiswa?.asalSekolah.isNotEmpty == true
        ? _mahasiswa!.asalSekolah
        : '-';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: AppColors.navy,
              ),
              SizedBox(width: 8),
              Text(
                'Data Pribadi & Kontak',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _DetailRow(
            icon: Icons.wc_outlined,
            label: 'Jenis Kelamin',
            value: gender,
          ),
          _DetailRow(
            icon: Icons.cake_outlined,
            label: 'Tempat, Tgl Lahir',
            value: ttl,
          ),
          _DetailRow(icon: Icons.mosque_outlined, label: 'Agama', value: agama),
          _DetailRow(
            icon: Icons.flag_outlined,
            label: 'Kewarganegaraan',
            value: warganegara,
          ),
          _DetailRow(
            icon: Icons.favorite_border_rounded,
            label: 'Status Pernikahan',
            value: statusNikah,
          ),
          _DetailRow(
            icon: Icons.email_outlined,
            label: 'Email Kampus',
            value: email,
          ),
          _DetailRow(
            icon: Icons.phone_android_outlined,
            label: 'No. Handphone / WA',
            value: hp,
          ),
          _DetailRow(
            icon: Icons.phone_outlined,
            label: 'Telepon Rumah',
            value: telp,
          ),
          _DetailRow(
            icon: Icons.home_outlined,
            label: 'Alamat Domisili',
            value: alamat,
          ),
          _DetailRow(
            icon: Icons.account_balance_outlined,
            label: 'Asal Sekolah',
            value: sekolah,
          ),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.navy),
          const SizedBox(width: 10),
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, color: AppColors.muted),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
