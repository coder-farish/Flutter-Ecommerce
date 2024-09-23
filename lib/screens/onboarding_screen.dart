import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:myproject/screens/home_screen.dart'; // Import the HomeScreen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and fade animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start the fade-in animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: IntroductionScreen(
        pages: [
          _buildPage(
            "Fitters For Men",
            "Step into style with the latest trends - where your wardrobe meets the future.",
            'assets/images/onboarding1.jpg',
            context,
          ),
          _buildPage(
            "Shop 24/7",
            "Shop your style, anytime, anywhere - fashion at your fingertips!",
            'assets/images/onboarding2.jpeg',
            context,
          ),
          _buildPage(
            "Express Delivery",
            "Fast fashion, faster delivery - your style arrives in no time!",
            'assets/images/onboarding3.jpeg',
            context,
          ),
        ],
        onDone: () =>
            _navigateToHome(context), // Navigate to HomeScreen on done
        onSkip: () =>
            _navigateToHome(context), // Navigate to HomeScreen on skip
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        next: Icon(
          Icons.arrow_forward,
          size: 24,
          color: theme.colorScheme.primary,
        ),
        done: Text(
          "Start",
          style: theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size(10.0, 10.0),
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          activeSize: const Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          activeColor: theme.colorScheme.primary,
        ),
      ),
    );
  }

  PageViewModel _buildPage(
      String title, String body, String imagePath, BuildContext context) {
    final theme = Theme.of(context);

    return PageViewModel(
      title: title,
      body: body,
      image: _buildOnboardingImage(imagePath, context),
      decoration: PageDecoration(
        titleTextStyle: theme.textTheme.headlineMedium!.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
        bodyTextStyle: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        imagePadding: const EdgeInsets.all(24),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(), // Navigate to HomeScreen
      ),
    );
  }

  Widget _buildOnboardingImage(String imagePath, BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4), // Shadow offset
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.surface.withOpacity(0.0),
                  theme.colorScheme.surface.withOpacity(0.4),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
