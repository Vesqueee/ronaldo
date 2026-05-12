import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class AddExperienceScreen extends StatelessWidget {
  const AddExperienceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppTheme.textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Experience',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'DONE',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),

            // Name Field
            const Text(
              'Name',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Experience\'s Name',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.borderLightColor),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Location Field
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Location of Experience',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.borderLightColor),
                ),
              ),
            ),

            const SizedBox(height: 48),

            // Upload Photos
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.primaryColor,
                  style: BorderStyle.solid,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
                color: AppTheme.primaryColor.withOpacity(0.05),
              ),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.photo_camera_outlined,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Upload Photos',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
