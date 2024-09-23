import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myproject/screens/onboarding_screen.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _animationController.forward();

    // Start the timer for navigation
    Timer(const Duration(seconds: 5), () {
      _navigateToOnboarding();
    });
  }

  // Dispose the animation controller to prevent memory leaks
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToOnboarding() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Use FadeTransition for splash image
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildSplashImage(context),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 350,
                  child: FAProgressBar(
                    currentValue: 100,
                    size: 8,
                    borderRadius: BorderRadius.circular(1),
                    animatedDuration: const Duration(seconds: 2),
                    changeColorValue: 1000,
                    backgroundColor: theme.colorScheme.surface,
                    progressColor: theme.colorScheme.primary,
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Loading...',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplashImage(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 350, // Fixed width
      height: 220, // Fixed height
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/ffm2.jpg', // Ensure this image is in your assets folder
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
