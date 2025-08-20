import 'package:flutter/material.dart';
import '../constants/colors.dart';

class BaseTemplate extends StatelessWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool showMenu;
  final VoidCallback? onMenuPressed;
  final bool showProfile;
  final VoidCallback? onProfilePressed;

  const BaseTemplate({
    super.key,
    required this.child,
    this.title = 'Calmflect',
    this.showBackButton = true,
    this.onBackPressed,
    this.showMenu = true,
    this.onMenuPressed,
    this.showProfile = true,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.slate50, AppColors.blue50, AppColors.indigo100],
          ),
        ),
        child: Stack(
          children: [
            // Background geometric patterns
            Positioned.fill(
              child: CustomPaint(painter: GeometricBackgroundPainter()),
            ),

            // Main content
            Column(
              children: [
                // Header
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // Left side
                          if (showBackButton)
                            IconButton(
                              onPressed:
                                  onBackPressed ??
                                  () {
                                    if (Navigator.of(context).canPop()) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.slate700,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          else if (showMenu)
                            IconButton(
                              onPressed: onMenuPressed,
                              icon: const Icon(
                                Icons.menu,
                                color: AppColors.slate700,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 48),

                          // Center - Title
                          Expanded(
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 600),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.slate900,
                                letterSpacing: 1.2,
                                shadows: [
                                  Shadow(
                                    blurRadius: 6,
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          // Right side
                          if (showProfile)
                            IconButton(
                              onPressed: onProfilePressed,
                              icon: const Icon(
                                Icons.person_outline,
                                color: AppColors.slate700,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 48),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Expanded(child: child),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GeometricBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Large circle top-right
    paint.shader =
        RadialGradient(
          colors: [
            AppColors.blue200.withValues(alpha: 0.4),
            AppColors.indigo200.withValues(alpha: 0.4),
          ],
        ).createShader(
          Rect.fromCircle(center: Offset(size.width + 60, -60), radius: 160),
        );
    canvas.drawCircle(Offset(size.width + 60, -60), 160, paint);

    // Medium circle bottom-left
    paint.shader =
        RadialGradient(
          colors: [
            AppColors.slate200.withValues(alpha: 0.3),
            AppColors.blue200.withValues(alpha: 0.3),
          ],
        ).createShader(
          Rect.fromCircle(center: Offset(-120, size.height + 120), radius: 192),
        );
    canvas.drawCircle(Offset(-120, size.height + 120), 192, paint);

    // Small accent circles
    paint.shader =
        RadialGradient(
          colors: [
            AppColors.indigo300.withValues(alpha: 0.2),
            AppColors.blue300.withValues(alpha: 0.2),
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(size.width * 0.75, size.height * 0.33),
            radius: 64,
          ),
        );
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.33), 64, paint);

    paint.shader =
        RadialGradient(
          colors: [
            AppColors.slate300.withValues(alpha: 0.25),
            AppColors.indigo300.withValues(alpha: 0.25),
          ],
        ).createShader(
          Rect.fromCircle(
            center: Offset(size.width * 0.33, size.height * 0.67),
            radius: 48,
          ),
        );
    canvas.drawCircle(Offset(size.width * 0.33, size.height * 0.67), 48, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
