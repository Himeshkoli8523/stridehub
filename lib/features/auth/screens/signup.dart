import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stridehub/core/constants/colors.dart';
import 'package:stridehub/routes/app_routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);
  final ValueNotifier<String?> _emailError = ValueNotifier(null);
  final ValueNotifier<String?> _passwordError = ValueNotifier(null);
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_checkPasswordsMatch);
    _confirmPasswordController.addListener(_checkPasswordsMatch);
  }

  void _validateEmail() async {
    final email = _emailController.text;
    if (email.isNotEmpty && RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      try {
        final methods = await _auth.fetchSignInMethodsForEmail(email);
        if (methods.isNotEmpty) {
          _emailError.value = 'Email already exists';
        } else {
          _emailError.value = null;
        }
      } catch (e) {
        _emailError.value = 'Error checking email';
      }
    } else if (email.isNotEmpty) {
      _emailError.value = 'Invalid email format';
    } else {
      _emailError.value = null;
    }
    _checkPasswordsMatch();
  }

  void _checkPasswordsMatch() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password != confirmPassword) {
      _passwordError.value = 'Passwords do not match';
    } else if (password.isNotEmpty &&
        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
            .hasMatch(password)) {
      _passwordError.value =
          'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
    } else {
      _passwordError.value = null;
    }

    _isButtonEnabled.value = _emailError.value == null &&
        _passwordError.value == null &&
        password == confirmPassword;
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      _showErrorDialog('Failed to sign up: $e');
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

  void _showPasswordRequirements() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Password Requirements'),
          content: Text(
            'Your password must contain:\n'
            '- At least one uppercase letter\n'
            '- At least one lowercase letter\n'
            '- At least one digit\n'
            '- At least one special character\n'
            '- Minimum 8 characters',
          ),
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
                    "Create your StrideHub account",
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
            _buildPasswordField('Password', _passwordController,
                _obscurePassword, _passwordError),
            _buildPasswordField('Confirm Password', _confirmPasswordController,
                _obscureConfirmPassword, null),
            SizedBox(height: 20),
            Center(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isButtonEnabled,
                builder: (context, isEnabled, child) {
                  return ElevatedButton(
                    onPressed: isEnabled ? _signUp : null,
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor:
                          isEnabled ? AppColors.buttonColor : Colors.grey,
                      foregroundColor: AppColors.buttonTextColor,
                      minimumSize:
                          Size(double.infinity, 50), // Full width button
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: Text(
                  'Already have an account? Login',
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

  Widget _buildPasswordField(
      String label,
      TextEditingController controller,
      ValueNotifier<bool> obscureTextNotifier,
      ValueNotifier<String?>? errorNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: ValueListenableBuilder<String?>(
        valueListenable: errorNotifier ?? ValueNotifier(null),
        builder: (context, errorText, child) {
          return ValueListenableBuilder<bool>(
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
                  errorText: errorText,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          obscureTextNotifier.value =
                              !obscureTextNotifier.value;
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.info_outline),
                        onPressed: _showPasswordRequirements,
                      ),
                    ],
                  ),
                ),
                style: TextStyle(color: AppColors.textColor),
              );
            },
          );
        },
      ),
    );
  }
}
