import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../widgets/floating_pill_nav_bar.dart';
import 'home_screen.dart';
import 'info_screen.dart';
import 'news_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  final VoidCallback onLogout;
  final UserModel? user;
  final bool showWelcomeAlert;

  const MainShell({
    super.key,
    required this.onLogout,
    this.user,
    this.showWelcomeAlert = false,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 340),
      curve: const Cubic(0.22, 1.0, 0.36, 1.0),
    );
  }

  void _showComingSoon(String title) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$title - segera hadir'),
          duration: const Duration(milliseconds: 1200),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(
        user: widget.user,
        showWelcomeAlert: widget.showWelcomeAlert,
        onOpenMenu: _showComingSoon,
      ),
      const InfoScreen(),
      const NewsScreen(),
      ProfileScreen(
        user: widget.user,
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        physics: const BouncingScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FloatingPillNavBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _onTabTapped,
              items: const [
                FloatingPillNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home_rounded,
                  label: 'Beranda',
                ),
                FloatingPillNavItem(
                  icon: Icons.info_outline_rounded,
                  selectedIcon: Icons.info_rounded,
                  label: 'Info',
                ),
                FloatingPillNavItem(
                  icon: Icons.newspaper_outlined,
                  selectedIcon: Icons.newspaper_rounded,
                  label: 'Berita',
                ),
                FloatingPillNavItem(
                  icon: Icons.person_outline_rounded,
                  selectedIcon: Icons.person_rounded,
                  label: 'Profil',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
