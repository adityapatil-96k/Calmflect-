import 'dart:ui';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../components/widgets/floating_chat_button.dart';
import 'package:provider/provider.dart';
import '../../contexts/auth_context.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _goToLogin(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    // Call logout
    await auth.logout();

    if (context.mounted) {
      // Navigate back to login page
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F2F1),
      //bottom navigation dock
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: 30,
        ), // float above bottom
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.slate900.withValues(alpha: .35), // glassy
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: .3),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _DockIcon(icon: Icons.home, label: 'Menu', route: '/'),
                _DockIcon(icon: Icons.warning, label: 'SOS', route: '/sos'),
                _DockIcon(
                  icon: Icons.person,
                  label: 'Profile',
                  route: '/profile',
                ),
                _DockIcon(
                  icon: Icons.settings,
                  label: 'Settings',
                  route: '/settings',
                ),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome To,',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Calmflect 👋',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap:() => _goToLogin(context),
                    child:CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.slate900,
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  )
                  
                ],
              ),
              const SizedBox(height: 20),

              // Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.blue500.withValues(alpha: .85),
                      AppColors.purple500.withValues(alpha: .85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.purple500.withValues(alpha: .3),
                      blurRadius: 18,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Text(
                  '“Take a deep breath and reflect on your day.”',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 28),

              // First row (Mood, Journal, Meditation)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: HomeGlassCard(
                      title: 'Mood',
                      icon: Icons.mood,
                      color: AppColors.green500,
                      route: '/mood',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: HomeGlassCard(
                      title: 'Journal',
                      icon: Icons.book,
                      color: AppColors.orange500,
                      route: '/journal',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: HomeGlassCard(
                      title: 'Meditation',
                      icon: Icons.self_improvement,
                      color: AppColors.purple500,
                      route: '/meditation',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Grid for other features
              Transform.translate(
                offset: Offset(0, -15),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 18,
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  childAspectRatio: 1.1,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 0,
                  ),
                  children: const [
                    HomeGlassCard(
                      title: 'Therapy',
                      icon: Icons.health_and_safety,
                      color: AppColors.teal500,
                      route: '/therapy',
                      height: 80,
                    ),
                    HomeGlassCard(
                      title: 'Chemo Support',
                      icon: Icons.local_hospital,
                      color: AppColors.pink500,
                      route: '/chemosupport',
                      height: 80,
                    ),
                    HomeGlassCard(
                      title: 'Founder Reset',
                      icon: Icons.refresh,
                      color: AppColors.amber500,
                      route: '/founderreset',
                      height: 80,
                    ),
                    HomeGlassCard(
                      title: 'Legal',
                      icon: Icons.gavel,
                      color: AppColors.gray700,
                      route: '/legal',
                      height: 80,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GlassChatButton(
        onTap: () {
          // Action for FAB
          Navigator.pushNamed(context, '/chatbot');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// One unified GLASS card (used for all 7)
class HomeGlassCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String route;
  final double? width;
  final double? height;

  const HomeGlassCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .28),
              blurRadius: 22,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              // tinted base (stronger so it doesn't wash out)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: .80),
                      color.withValues(alpha: .55),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // frost + highlight
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .28),
                      width: 1.2,
                    ),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(60, 255, 255, 255), // subtle top gloss
                        Color.fromARGB(10, 255, 255, 255), // fade
                      ],
                      stops: [0.0, 0.6],
                    ),
                  ),
                ),
              ),
              // content
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 40, color: Colors.white),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black26,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DockIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final String route;

  const _DockIcon({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  State<_DockIcon> createState() => _DockIconState();
}

class _DockIconState extends State<_DockIcon>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 1.3),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        Navigator.pushNamed(context, widget.route);
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _scale,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, size: 28, color: Colors.white),
            Text(
              widget.label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

