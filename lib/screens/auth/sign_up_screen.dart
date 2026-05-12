import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'sign_up_step1_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _role = 1; // 0 for Traveler, 1 for Guide
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      _showMessage('Vui lòng nhập đầy đủ thông tin.');
      return;
    }

    if (password.length < 6) {
      _showMessage('Mật khẩu phải có ít nhất 6 ký tự.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Mật khẩu và xác nhận mật khẩu không khớp.');
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await ApiService.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        role: _role == 1 ? 'guide' : 'traveler',
      );

      if (response['success'] == true) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignUpStep1Screen()),
        );
      } else {
        _showMessage(response['message'] ?? 'Đăng ký thất bại.');
      }
    } catch (e) {
      _showMessage('Lỗi kết nối. Vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeader(height: 200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Row(
                        children: [
                          Radio<int>(
                            value: 0,
                            groupValue: _role,
                            onChanged: (val) => setState(() => _role = val!),
                          ),
                          const Text('Traveler'),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        children: [
                          Radio<int>(
                            value: 1,
                            groupValue: _role,
                            onChanged: (val) => setState(() => _role = val!),
                          ),
                          const Text('Guide'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'First Name',
                          hint: 'Tuan',
                          controller: _firstNameController,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: 'Last Name',
                          hint: 'Tran',
                          controller: _lastNameController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Email',
                    hint: 'Type email',
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Password',
                    hint: 'Type password',
                    isPassword: true,
                    controller: _passwordController,
                  ),
                  const Text(
                    'Password has more than 6 letters.',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: 'Confirm Password',
                    hint: '••••••',
                    isPassword: true,
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'By Signing Up, you agree to our ',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: _loading ? 'Signing up...' : 'SIGN UP',
                    onPressed: _loading ? () {} : _signUp,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
