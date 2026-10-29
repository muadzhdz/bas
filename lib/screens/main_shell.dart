import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_model.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'info_screen.dart';
import 'news_screen.dart';
import 'profile_screen.dart';

class _ShellNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _ShellNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

class MainShell extends StatefulWidget {
  final VoidCallback onLogout;
  final UserModel? user;

  const MainShell({
    super.key,
    required this.onLogout,
    this.user,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  late final PageController _pageController;

  static const List<String> _pageTitles = [
    'Beranda',
    'Info Kampus',
    'Berita',
    'Profil',
  ];

  static const List<_ShellNavItem> _navItems = [
    _ShellNavItem(
      icon: Icons.grid_view_outlined,
      selectedIcon: Icons.grid_view_rounded,
      label: 'Beranda',
    ),
    _ShellNavItem(
      icon: Icons.info_outline_rounded,
      selectedIcon: Icons.info_rounded,
      label: 'Info',
    ),
    _ShellNavItem(
      icon: Icons.newspaper_outlined,
      selectedIcon: Icons.newspaper_rounded,
      label: 'Berita',
    ),
    _ShellNavItem(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profil',
    ),
  ];

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
    HapticFeedback.lightImpact();
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: Text(
            _pageTitles[_currentIndex],
            key: ValueKey<int>(_currentIndex),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        // ClampingScrollPhysics mengunci batas kiri & kanan tanpa overscroll / void
        physics: const ClampingScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 62,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isSelected = _currentIndex == index;
                final iconData = isSelected ? item.selectedIcon : item.icon;

                return Expanded(
                  child: InkWell(
                    onTap: () => _onTabTapped(index),
                    splashColor: AppColors.navy.withValues(alpha: 0.08),
                    highlightColor: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                          width: 54,
                          height: 30,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.navy.withValues(alpha: 0.10)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Icon(
                              iconData,
                              size: 22,
                              color: isSelected ? AppColors.navy : AppColors.muted,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? AppColors.navy : AppColors.muted,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
