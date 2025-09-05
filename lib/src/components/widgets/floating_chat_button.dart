import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class GlassChatButton extends StatelessWidget {
  final VoidCallback onTap;

  const GlassChatButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: LinearGradient(
            colors: [
              AppColors.blue500.withValues(alpha: .8),
              AppColors.purple500.withValues(alpha: .6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: .25),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue500.withValues(alpha: .45),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Center(
              child: Icon(
                Icons.chat_bubble,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}