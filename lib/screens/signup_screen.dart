import 'package:flutter/material.dart';
import 'package:myproject/data/user_db.dart'; // Import your DatabaseHelper

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Function to create a new user
  Future<void> _signupUser() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      String fullName = _fullNameController.text;
      String address = _addressController.text;

      final dbHelper =
          UserDatabaseHelper(); // Create an instance of DatabaseHelper

      // Check if user already exists
      final existingUser = await dbHelper.getUserByEmail(email);
      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User already exists with this email.')),
        );
        return;
      }

      // Insert new user into the database
      await dbHelper.insertUser({
        'email': email,
        'password': password,
        'fullName': fullName,
        'address': address,
        'isAdmin': 0, // By default, a new user is not an admin
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User created successfully!')),
      );

      // Navigate to login screen after successful signup
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                    label: 'Full Name',
                    controller: _fullNameController,
                    theme: theme,
                    isPassword: false),
                const SizedBox(height: 16),
                _buildAnimatedTextField(
                    label: 'Address',
                    controller: _addressController,
                    theme: theme,
                    isPassword: false),
                const SizedBox(height: 16),
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
                _buildSignupButton(theme),
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
        keyboardType:
            isPassword ? TextInputType.visiblePassword : TextInputType.text,
        obscureText: isPassword,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          if (label == 'Email') {
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          }
          if (label == 'Password' && value.length < 6) {
            return 'Password must be at least 6 characters long';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSignupButton(ThemeData theme) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _fadeAnimation,
        curve: Curves.easeInOut,
      )),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _signupUser,
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
            'Sign Up',
            style: TextStyle(
              color: theme.colorScheme.onPrimary, // Text color
            ),
          ),
        ),
      ),
    );
  }
}
