import 'package:flutter/material.dart';
import 'package:myproject/data/user_db.dart'; // Import your DatabaseHelper
import 'package:myproject/screens/home_screen.dart'; // Import the HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Hardcoded admin credentials
  static const String adminUsername = 'admin';
  static const String adminPassword = 'admin24';

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
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Function to log in the user
  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      // Check if the entered credentials match the hardcoded admin credentials
      if (email == adminUsername && password == adminPassword) {
        // Navigate to admin panel or home screen as admin
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin login successful!')),
        );
        Navigator.pushReplacementNamed(context, '/admin-panel');
        return;
      }

      // If not admin, proceed with database check
      final user =
          await UserDatabaseHelper().getUserByEmailAndPassword(email, password);

      if (user != null) {
//        int userId = user['id']; // Ensure user ID is correctly retrieved
        bool isAdmin = user['isAdmin'] == 1; // Check if the user is an admin

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        if (isAdmin) {
          Navigator.pushReplacementNamed(context, '/admin-panel');
        } else {
          _navigateToHome();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password.')),
        );
      }
    }
  }

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false, // Clear all navigation history
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAnimatedTextField(
                    label: 'Email',
                    controller: _emailController,
                    theme: theme,
                    isPassword: false),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                    label: 'Password',
                    controller: _passwordController,
                    theme: theme,
                    isPassword: true),
                const SizedBox(height: 24),
                _buildLoginButton(theme),
                const SizedBox(height: 16),
                _buildSignupButton(theme),
                const SizedBox(height: 8),
                _buildClearTraceButton(theme), // New button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField(
      {required String label,
      required TextEditingController controller,
      required ThemeData theme,
      required bool isPassword}) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _fadeAnimation,
        curve: Curves.easeInOut,
      )),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.iconTheme.color),
        ),
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLoginButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _loginUser,
        style: ElevatedButton.styleFrom(
          foregroundColor:
              theme.elevatedButtonTheme.style?.foregroundColor?.resolve({}),
          backgroundColor:
              theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text(
          'Login',
          style: TextStyle(
            color: theme.colorScheme.onPrimary, // Text color
          ),
        ),
      ),
    );
  }

  Widget _buildSignupButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/signup');
        },
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary, // Text color
        ),
        child: Text(
          'Don\'t have an account? Sign up',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildClearTraceButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          _navigateToHome(); // Navigate to home screen and clear navigation history
        },
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.secondary, // Text color
        ),
        child: Text(
          'Back to Home Page',
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
