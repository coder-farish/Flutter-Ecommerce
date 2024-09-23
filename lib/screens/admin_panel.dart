import 'package:flutter/material.dart';
import 'package:myproject/screens/home_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and fade animation
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section Title
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Manage Store',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Items Management Button
              _buildAnimatedButton(
                icon: Icons.inventory,
                label: 'Items Management',
                onPressed: () {
                  Navigator.pushNamed(context, '/items-management');
                },
                theme: theme,
              ),
              const SizedBox(height: 16),
              // Order Management Button
              _buildAnimatedButton(
                icon: Icons.receipt_long,
                label: 'Add Dummy Data',
                onPressed: () {
                  Navigator.pushNamed(context, '/data-management');
                },
                theme: theme,
              ),
              const SizedBox(height: 16),
              // Users Management Button
              _buildAnimatedButton(
                icon: Icons.people,
                label: 'Users Management',
                onPressed: () {
                  Navigator.pushNamed(context, '/users-management');
                },
                theme: theme,
              ),
              const Spacer(), // Pushes the logout button to the bottom
              // Divider for logout section
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
              const SizedBox(height: 16),
              // Logout Button
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    ModalRoute.withName('/'),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.redAccent,
                  textStyle:
                      theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to build animated buttons with slide transition
  Widget _buildAnimatedButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required ThemeData theme,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1), // Starts from the bottom
        end: Offset.zero, // Moves to its final position
      ).animate(CurvedAnimation(
        parent: _fadeAnimation,
        curve: Curves.easeInOut,
      )),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28), // Added icon for better UX
        label: Text(label, style: theme.textTheme.labelLarge),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          textStyle: theme.textTheme.labelLarge,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12), // Rounded corners for buttons
          ),
        ),
      ),
    );
  }
}
