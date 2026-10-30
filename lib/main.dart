import 'package:flutter/material.dart';

import 'models/user_model.dart';
import 'pages/auth_page.dart';
import 'screens/main_shell.dart';
import 'services/session_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final UserModel? savedUser = await SessionService.getUser();
  runApp(MyApp(initialUser: savedUser));
}

class MyApp extends StatefulWidget {
  final UserModel? initialUser;

  const MyApp({super.key, this.initialUser});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  void _onLogout() async {
    await SessionService.clearUser();
    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Boash Academic System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: widget.initialUser != null
          ? MainShell(user: widget.initialUser, onLogout: _onLogout)
          : const AuthPage(),
    );
  }
}
