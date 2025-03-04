import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridehub/core/constants/colors.dart';
import 'package:stridehub/routes/app_routes.dart';
import 'package:stridehub/features/auth/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final ValueNotifier<String?> _emailError = ValueNotifier(null);
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
    _emailController.addListener(_validateEmail);
  }

  Future<void> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  void _validateEmail() {
    final email = _emailController.text;
    if (email.isNotEmpty && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      _emailError.value = 'Invalid email format';
    } else {
      _emailError.value = null;
    }
  }

  Future<void> _login() async {
    try {
      await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      _showErrorDialog('Failed to login: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "StrideHub",
          style: GoogleFonts.dosis(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.textColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.directions_run,
                      size: 100, color: AppColors.primaryColor),
                  SizedBox(height: 10),
                  Text(
                    "Welcome to StrideHub",
                    style: GoogleFonts.dosis(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            _buildTextField('Email', _emailController, false, _emailError),
            _buildPasswordField(
                'Password', _passwordController, _obscurePassword),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: AppColors.buttonColor,
                  foregroundColor: AppColors.buttonTextColor,
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.signup);
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      bool obscureText, ValueNotifier<String?>? errorNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder<String?>(
        valueListenable: errorNotifier ?? ValueNotifier(null),
        builder: (context, errorText, child) {
          return TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: AppColors.captionColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.transparent,
              errorText: errorText,
            ),
            style: TextStyle(color: AppColors.textColor),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      ValueNotifier<bool> obscureTextNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: obscureTextNotifier,
        builder: (context, obscureText, child) {
          return TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: AppColors.captionColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.transparent,
              suffixIcon: IconButton(
                icon:
                    Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  obscureTextNotifier.value = !obscureTextNotifier.value;
                },
              ),
            ),
            style: TextStyle(color: AppColors.textColor),
          );
        },
      ),
    );
  }
}
