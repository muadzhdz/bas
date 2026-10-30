import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

class FloatingPillNavItem {
  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final int badgeCount;

  const FloatingPillNavItem({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badgeCount = 0,
  });
}

class FloatingPillNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<FloatingPillNavItem> items;
  final double scale;

  final Color surfaceColor;
  final Color borderColor;
  final Color activeColor;
  final Color onActiveColor;
  final Color inactiveColor;

  const FloatingPillNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
    this.scale = 1.15,
    this.surfaceColor = AppColors.white,
    this.borderColor = AppColors.border,
    this.activeColor = AppColors.navy,
    this.onActiveColor = AppColors.white,
    this.inactiveColor = AppColors.muted,
  });

  @override
  Widget build(BuildContext context) {
    final double s = scale;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0B2545),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 8 * s, vertical: 7 * s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isActive = selectedIndex == index;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.5 * s),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!isActive) {
                  HapticFeedback.lightImpact();
                  onDestinationSelected(index);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                padding: EdgeInsets.symmetric(
                  horizontal: (isActive ? 16 : 12) * s,
                  vertical: 9 * s,
                ),
                decoration: BoxDecoration(
                  color: isActive ? activeColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          isActive
                              ? (item.selectedIcon ?? item.icon)
                              : item.icon,
                          size: 22 * s,
                          color: isActive ? onActiveColor : inactiveColor,
                        ),
                        if (item.badgeCount > 0)
                          Positioned(
                            top: -4 * s,
                            right: -6 * s,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 4.5 * s,
                                vertical: 1.5 * s,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gold,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 15 * s,
                                minHeight: 15 * s,
                              ),
                              child: Text(
                                item.badgeCount > 9
                                    ? '9+'
                                    : '${item.badgeCount}',
                                style: TextStyle(
                                  color: AppColors.navyDark,
                                  fontSize: 9.5 * s,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 320),
                      curve: const Cubic(0.22, 1.0, 0.36, 1.0),
                      child: isActive
                          ? Padding(
                              padding: EdgeInsets.only(left: 7 * s),
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  color: onActiveColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13 * s,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
