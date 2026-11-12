import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class GenderAvatar extends StatelessWidget {
  final bool isFemale;
  final double size;
  final bool showBorder;
  final Color? borderColor;

  const GenderAvatar({
    super.key,
    required this.isFemale,
    this.size = 60,
    this.showBorder = true,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderCol = borderColor ?? AppColors.gold;

    final List<Color> gradientColors = isFemale
        ? const [Color(0xFF831843), Color(0xFFBE185D)]
        : const [Color(0xFF0F172A), Color(0xFF1E3A8A)];

    final IconData avatarIcon = isFemale
        ? Icons.face_3_rounded
        : Icons.face_6_rounded;

    return Container(
      width: size,
      height: size,
      padding: showBorder ? const EdgeInsets.all(2.5) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: showBorder ? borderCol : Colors.transparent,
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.28),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -size * 0.15,
                right: -size * 0.15,
                child: Container(
                  width: size * 0.6,
                  height: size * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Icon(avatarIcon, size: size * 0.62, color: AppColors.white),
            ],
          ),
        ),
      ),
    );
  }
}
