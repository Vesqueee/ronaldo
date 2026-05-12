import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'sign_up_step2_screen.dart';

class SignUpStep1Screen extends StatelessWidget {
  const SignUpStep1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const AuthHeader(height: 180),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        const Text(
                          'Welcome, Tuan!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    'Please finish your profile so that Travelers can find you easily!',
                    style: TextStyle(
                      color: AppTheme.textPrimaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Progress Bar Mock
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const CircleAvatar(
                            radius: 6,
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Background Info',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 50,
                        height: 2,
                        color: AppTheme.borderLightColor,
                        margin: const EdgeInsets.only(bottom: 12),
                      ),
                      Column(
                        children: [
                          const CircleAvatar(
                            radius: 6,
                            backgroundColor: AppTheme.borderLightColor,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fee & Time',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Profile Photo Placeholder
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const CustomTextField(label: 'Address', hint: 'Address'),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(
                        child: CustomTextField(label: 'City', hint: 'City'),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: 'Country',
                          hint: 'Country',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const CustomTextField(
                    label: 'Phone number',
                    hint: '(+84)   Phone number',
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Guide License'),
                  const SizedBox(height: 8),
                  _buildUploadBox('Upload Photo', Icons.camera_alt_outlined),
                  const SizedBox(height: 24),
                  _buildLabel('Identity Card'),
                  const SizedBox(height: 8),
                  _buildUploadBox('Upload Photo', Icons.camera_alt_outlined),
                  const SizedBox(height: 24),
                  const CustomTextField(
                    label: 'Languages',
                    hint: 'Languages you can use to guide',
                  ),
                  const SizedBox(height: 24),
                  _buildLabel('Introduction'),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Short introduction about yourself',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppTheme.borderLightColor,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: const BorderSide(
                          color: AppTheme.borderLightColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _buildLabel('Video Introduction '),
                      const Text(
                        '(Optional)',
                        style: TextStyle(
                          color: AppTheme.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'A video introduction will more impress Travelers',
                    style: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildUploadBox('Upload Video', Icons.videocam_outlined),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'NEXT',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpStep2Screen(),
                        ),
                      );
                    },
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryColor,
      ),
    );
  }

  Widget _buildUploadBox(String text, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppTheme.primaryColor,
          style: BorderStyle.solid,
        ), // In reality, design has dotted border
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 28),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
