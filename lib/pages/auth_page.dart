import 'package:flutter/material.dart';
import '../api/auth_api.dart';
import '../screens/main_shell.dart';

class AuthPage extends StatefulWidget {
  // Widget untuk halaman otentikasi (login)
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
  // Membuat state untuk AuthPage
}

class _AuthPageState extends State<AuthPage> {
  // Controller untuk input username
  final TextEditingController _usernameController = TextEditingController();
  // Controller untuk input password
  final TextEditingController _passwordController = TextEditingController();
  Map<String, dynamic>? _user;
  String? _message;
  bool _isLoading = false;

  @override
  // Menginisialisasi state
  void initState() {
    super.initState();
    _loadUser(); // ambil user saat halaman dibuka
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi ambil user
  void _loadUser() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });
    final api = AuthApi();
    // Mengambil user acak dari API
    final user = await api.fetchRandomUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  // Fungsi untuk mengisi username & password testing secara otomatis
  void _fillCredentials() {
    if (_user != null) {
      _usernameController.text = _user!['login']['username'] ?? '';
      _passwordController.text = _user!['login']['password'] ?? '';
    }
  }

  // Fungsi untuk proses login
  void _login() {
    if (_user == null) {
      setState(() {
        _message = 'User belum dimuat';
      });
      return;
    }
    // Mendapatkan username dari user API
    final username = _user!['login']['username'];
    // Mendapatkan password dari user API
    final password = _user!['login']['password'];
    // Memeriksa apakah username dan password cocok
    if (_usernameController.text == username &&
        _passwordController.text == password) {
      setState(() {
        _message = 'Login berhasil!';
      });
      // Jika tidak cocok
    } else {
      setState(() {
        _message = 'Username atau password salah';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan username dan password saat ini untuk ditampilkan
    final currentUsername = _user?['login']?['username'] ?? (_isLoading ? 'Memuat...' : '-');
    final currentPassword = _user?['login']?['password'] ?? (_isLoading ? 'Memuat...' : '-');
    final isSuccess = _message == 'Login berhasil!';

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // Widget di dalam kolom
            children: [
              const Text('Username'),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 10),
              // Input untuk password
              const Text('Password'),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(border: UnderlineInputBorder()),
              ),
              // Tombol login
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
              // Menampilkan pesan
              const SizedBox(height: 20),
              if (_message != null)
                Text(
                  _message!,
                  style: TextStyle(
                    color: isSuccess ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (isSuccess) ...[
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainShell(
                          onLogout: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.dashboard_rounded),
                  label: const Text('Masuk ke Dashboard Sistem Boash'),
                ),
              ],
              const Divider(height: 30),
              const Text("User login dari API (untuk testing):"),
              const SizedBox(height: 4),
              SelectableText("Username: $currentUsername"),
              SelectableText("Password: $currentPassword"),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Tombol untuk mengganti user acak
                  ElevatedButton(
                    onPressed: _isLoading ? null : _loadUser,
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Ganti User Acak'),
                  ),
                  const SizedBox(width: 10),
                  // Tombol praktis untuk auto-fill testing
                  OutlinedButton(
                    onPressed: _user == null ? null : _fillCredentials,
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
