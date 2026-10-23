import 'package:flutter/material.dart';

import '../api/auth_api.dart';
import '../models/user_model.dart';
import '../screens/main_shell.dart';
import '../theme/app_theme.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthApi _authApi = AuthApi();
  UserModel? _apiUser;
  UserModel? _loggedInUser;
  String? _message;
  bool _isSuccess = false;
  bool _isLoading = false;
  bool _isVerifying = false;
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    try {
      final user = await _authApi.fetchFirstUser();
      if (!mounted) return;
      setState(() {
        _apiUser = user;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  void _fillCredentials() {
    if (_apiUser != null) {
      _usernameController.text = _apiUser!.userid.toString();
      _passwordController.text = _apiUser!.userid.toString();
    }
  }

  Future<void> _login() async {
    setState(() {
      _isVerifying = true;
      _message = null;
    });

    final result = await _authApi.verifyLogin(
      npm: _usernameController.text,
      rawPassword: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
      _isSuccess = result.isSuccess;
      _message = result.message;
      _loggedInUser = result.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentNpm = _apiUser?.userid.toString() ?? (_isLoading ? 'Memuat...' : '-');
    final currentName = _apiUser?.nama ?? (_isLoading ? 'Memuat...' : '-');
    final currentSha1 = _apiUser?.passSha1 ?? (_isLoading ? 'Memuat...' : '-');

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Header Brand Section
              _buildBrandHeader(),
              const SizedBox(height: 28),

              // Form Login Card
              _buildFormCard(),

              // Status Result Banner (Success / Error)
              if (_message != null) ...[
                const SizedBox(height: 18),
                _buildMessageBanner(),
              ],

              // Tombol Masuk ke Dashboard (Saat Berhasil)
              if (_isSuccess && _loggedInUser != null) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainShell(
                          user: _loggedInUser,
                          onLogout: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.dashboard_rounded, color: AppColors.gold),
                  label: const Text(
                    'Masuk ke Dashboard Sistem Boash',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Testing Card untuk Dosen (MockAPI Information)
              _buildTestingPanel(currentNpm, currentName, currentSha1),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.school_rounded,
              color: AppColors.gold,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'SISTEM AKADEMIK BOASH',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w800,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Portal Mahasiswa',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Silakan masuk menggunakan NPM dan kata sandi Anda',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label Username (NPM)
          const Text(
            'Username',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _usernameController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.navy, size: 20),
              hintText: 'Masukkan NPM (contoh: 12523030)',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.muted),
              filled: true,
              fillColor: AppColors.offWhite,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.navy, width: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Label Password
          const Text(
            'Password',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _passwordController,
            obscureText: _isPasswordObscured,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.navy, size: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.muted,
                  size: 20,
                ),
                onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
              ),
              hintText: 'Masukkan Password',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.muted),
              filled: true,
              fillColor: AppColors.offWhite,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.navy, width: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Tombol Login (ElevatedButton)
          ElevatedButton(
            onPressed: _isVerifying ? null : _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: AppColors.white,
              minimumSize: const Size.fromHeight(50),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            child: _isVerifying
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: AppColors.white,
                    ),
                  )
                : const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isSuccess ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isSuccess ? const Color(0xFF86EFAC) : const Color(0xFFFECACA),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            color: _isSuccess ? const Color(0xFF16A34A) : AppColors.danger,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _message!,
                  style: TextStyle(
                    color: _isSuccess ? const Color(0xFF15803D) : AppColors.danger,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                if (_isSuccess && _loggedInUser != null) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildStatusChip('Role: ${_loggedInUser!.roleid} (Mhs)'),
                      _buildStatusChip('Status: ${_loggedInUser!.status == 1 ? "Aktif" : "Nonaktif"}'),
                      _buildStatusChip('KRS: ${_loggedInUser!.isKrsAktif ? "Aktif" : "Nonaktif"}'),
                      _buildStatusChip('Absen: ${_loggedInUser!.isAbsenAktif ? "Aktif" : "Nonaktif"}'),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF166534),
        ),
      ),
    );
  }

  Widget _buildTestingPanel(String currentNpm, String currentName, String currentSha1) {
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
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.goldSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.code_rounded, color: AppColors.navy, size: 16),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'User login dari API (untuk testing):',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'MockAPI Live',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('NPM (userid)', currentNpm),
          _buildInfoRow('Nama', currentName),
          _buildInfoRow('Password test', currentNpm),
          _buildInfoRow('pass_sha1', currentSha1.length > 20 ? '${currentSha1.substring(0, 16)}...' : currentSha1),
          if (_apiUser != null) ...[
            _buildInfoRow(
              'Akses',
              'Role: ${_apiUser!.roleid} • Status: ${_apiUser!.status} • Absen: ${_apiUser!.babsen} • KRS: ${_apiUser!.bperwalian} • Ujian: ${_apiUser!.bujian}',
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : _loadUser,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh_rounded, size: 16),
                  label: const Text('Muat Ulang API'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.navy,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _apiUser == null ? null : _fillCredentials,
                  icon: const Icon(Icons.auto_fix_high_rounded, size: 16),
                  label: const Text('Isi Otomatis'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: AppColors.navyDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.muted),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 12, color: AppColors.muted)),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(
                fontSize: 12,
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
