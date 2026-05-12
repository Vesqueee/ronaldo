import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthHeader extends StatelessWidget {
  final Widget? child;
  final double height;

  const AuthHeader({super.key, this.child, this.height = 250});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderClipper(),
      child: Container(
        height: height,
        width: double.infinity,
        color: AppTheme.primaryColor,
        child: Stack(
          children: [
            // Background decorations (clouds/planes)
            Positioned(
              top: 50,
              right: 20,
              child: Icon(
                Icons.airplanemode_active,
                color: Colors.white.withOpacity(0.2),
                size: 80,
              ),
            ),
            Positioned(
              bottom: 60,
              left: 30,
              child: Icon(
                Icons.cloud,
                color: Colors.white.withOpacity(0.2),
                size: 60,
              ),
            ),
            // The main content of the header
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fake App Logo
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'b',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'sans-serif',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ?child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    // First curve
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    // Second curve
    final secondControlPoint = Offset(size.width * 3 / 4, size.height - 60);
    final secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
