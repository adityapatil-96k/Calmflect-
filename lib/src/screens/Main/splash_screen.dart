// splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation for text
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Keep splash for exactly 3 seconds
    Timer(const Duration(seconds: 3), () {
     
      // Navigator.pushReplacement(...);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Center(
        child: Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Text(
                "Calmflect",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.indigo.shade600,
                  shadows: [
                    const Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 3,
                        color: Colors.black26),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}