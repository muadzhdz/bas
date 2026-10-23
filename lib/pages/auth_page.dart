import 'package:flutter/material.dart';
import '../api/auth_api.dart';
import '../models/user_model.dart';
import '../screens/main_shell.dart';

class AuthPage extends StatefulWidget {
  // Widget untuk halaman otentikasi (login)
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
  // Membuat state untuk AuthPage
}

class _AuthPageState extends State<AuthPage> {
  // Controller untuk input username (NPM)
  final TextEditingController _usernameController = TextEditingController();
  // Controller untuk input password
  final TextEditingController _passwordController = TextEditingController();

  final AuthApi _authApi = AuthApi();
  UserModel? _apiUser;
  UserModel? _loggedInUser;
  String? _message;
  bool _isSuccess = false;
  bool _isLoading = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _loadUser(); // ambil user dari MockAPI saat halaman dibuka
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi ambil user dari MockAPI
  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final user = await _authApi.fetchFirstUser();
      if (!mounted) return;
      setState(() {
        _apiUser = user;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk mengisi NPM & password testing secara otomatis
  void _fillCredentials() {
    if (_apiUser != null) {
      _usernameController.text = _apiUser!.userid.toString();
      // Password default testing adalah NPM (hash SHA-1 cocok dengan pass_sha1 di MockAPI)
      _passwordController.text = _apiUser!.userid.toString();
    }
  }

  // Fungsi untuk proses verifikasi login
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
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Username'),
              TextField(
                controller: _usernameController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Masukkan NPM (contoh: 12523030)',
                ),
              ),
              const SizedBox(height: 12),
              // Input untuk password
              const Text('Password'),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Masukkan Password',
                ),
              ),
              const SizedBox(height: 20),
              // Tombol login
              ElevatedButton(
                onPressed: _isVerifying ? null : _login,
                child: _isVerifying
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Login'),
              ),
              // Menampilkan pesan hasil verifikasi
              const SizedBox(height: 20),
              if (_message != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _isSuccess
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isSuccess ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _message!,
                        style: TextStyle(
                          color: _isSuccess ? Colors.green[800] : Colors.red[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      if (_isSuccess && _loggedInUser != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Role: ${_loggedInUser!.roleid} (Mahasiswa) • '
                          'Status: ${_loggedInUser!.status == 1 ? "Aktif (1)" : "Disable (0)"}\n'
                          'KRS: ${_loggedInUser!.isKrsAktif ? "Aktif (1)" : "Disable (0)"} • '
                          'Absen: ${_loggedInUser!.isAbsenAktif ? "Aktif (1)" : "Disable (0)"}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[900],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (_isSuccess) ...[
                const SizedBox(height: 14),
                ElevatedButton.icon(
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
                  icon: const Icon(Icons.dashboard_rounded),
                  label: const Text('Masuk ke Dashboard Sistem Boash'),
                ),
              ],
              const Divider(height: 36),
              const Text(
                'User login dari API (untuk testing):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SelectableText('NPM (userid): $currentNpm'),
              SelectableText('Nama: $currentName'),
              SelectableText('Password test: $currentNpm'),
              SelectableText('pass_sha1: $currentSha1'),
              if (_apiUser != null) ...[
                SelectableText(
                  'Role ID: ${_apiUser!.roleid} | '
                  'Status: ${_apiUser!.status} | '
                  'Absen: ${_apiUser!.babsen} | '
                  'KRS: ${_apiUser!.bperwalian}',
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _loadUser,
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Muat Ulang API'),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: _apiUser == null ? null : _fillCredentials,
                    child: const Text('Isi Otomatis'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
