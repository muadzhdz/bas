import 'package:flutter/material.dart';

import '../api/auth_api.dart';
import '../screens/main_shell.dart';
import '../theme/app_theme.dart';
import '../widgets/sweet_alert.dart';

class AuthPage extends StatefulWidget {
  final bool logoutSuccess;

  const AuthPage({super.key, this.logoutSuccess = false});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthApi _authApi = AuthApi();
  String? _errorMessage;
  bool _isVerifying = false;
  bool _isPasswordObscured = true;
  bool _showLogoutAlert = false;

  @override
  void initState() {
    super.initState();
    if (widget.logoutSuccess) {
      _showLogoutAlert = true;
      Future.delayed(const Duration(milliseconds: 2800), () {
        if (mounted) {
          setState(() => _showLogoutAlert = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    final result = await _authApi.verifyLogin(
      npm: _usernameController.text,
      rawPassword: _passwordController.text,
    );

    if (!mounted) return;

    if (result.isSuccess && result.user != null) {
      // 1. Tampilkan SweetAlert sukses login
      await SweetAlert.success(
        context: context,
        title: 'Login Berhasil!',
        message: 'Selamat datang, ${result.user!.nama}\nPortal Akademik siap digunakan.',
        autoCloseDuration: const Duration(milliseconds: 1800),
      );

      if (!mounted) return;

      // 2. Langsung beralih ke Beranda
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainShell(
            user: result.user,
            onLogout: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthPage(logoutSuccess: true),
                ),
              );
            },
          ),
        ),
      );
    } else {
      // Login gagal: tampilkan pesan error
      setState(() {
        _isVerifying = false;
        _errorMessage = result.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sweet Alert Toast: Anda Berhasil Logout
                if (_showLogoutAlert) ...[
                  _buildLogoutSuccessAlert(),
                  const SizedBox(height: 16),
                ],

                // Header Brand Section dengan Logo Asli Boash
                _buildBrandHeader(),
                const SizedBox(height: 32),

                // Form Login Card
                _buildFormCard(),

                // Error Message Banner (Hanya muncul jika login gagal)
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorBanner(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutSuccessAlert() {
    return AnimatedOpacity(
      opacity: _showLogoutAlert ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFDCFCE7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF86EFAC)),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Anda berhasil logout. Sampai jumpa kembali!',
                style: TextStyle(
                  color: Color(0xFF15803D),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/boash.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'SISTEM INFORMASI AKADEMIK',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 1.4,
            fontWeight: FontWeight.w900,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Universitas Boash',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
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
              fontWeight: FontWeight.w800,
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
              fontWeight: FontWeight.w800,
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
                fontWeight: FontWeight.w800,
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

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.danger, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                color: AppColors.danger,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
