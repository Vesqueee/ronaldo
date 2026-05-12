import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_button.dart';
import '../main/main_screen.dart';

class SignUpStep2Screen extends StatefulWidget {
  const SignUpStep2Screen({super.key});

  @override
  State<SignUpStep2Screen> createState() => _SignUpStep2ScreenState();
}

class _SignUpStep2ScreenState extends State<SignUpStep2Screen> {
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];
  String _selectedDay = 'Monday';

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
                  // Progress Bar Mock (Step 2 Active)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const CircleAvatar(
                            radius: 6,
                            backgroundColor: AppTheme.borderLightColor,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Background Info',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 50,
                        height: 2,
                        color: AppTheme.primaryColor,
                        margin: const EdgeInsets.only(bottom: 12),
                      ),
                      Column(
                        children: [
                          const CircleAvatar(
                            radius: 6,
                            backgroundColor: AppTheme.primaryColor,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fee & Time',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Set Fee',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'The price unit is US \$/hour',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.borderLightColor),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      children: [
                        _buildFeeRow('1 - 3 Travelers'),
                        const Divider(
                          height: 1,
                          color: AppTheme.borderLightColor,
                        ),
                        _buildFeeRow('4 - 6 Travelers'),
                        const Divider(
                          height: 1,
                          color: AppTheme.borderLightColor,
                        ),
                        _buildFeeRow('7 - 9 Travelers'),
                        const Divider(
                          height: 1,
                          color: AppTheme.borderLightColor,
                        ),
                        _buildFeeRow('10 - 14 Travelers'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Set Available Time',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'The time you can work on Fellow4U as a Guide',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _days.map((day) {
                        bool isSelected = day == _selectedDay;
                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedDay = day);
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.borderLightColor,
                              ),
                            ),
                            child: Text(
                              day,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppTheme.textPrimaryColor,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'From',
                            prefixIcon: const Icon(
                              Icons.access_time,
                              color: AppTheme.textSecondaryColor,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppTheme.borderLightColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'To',
                            prefixIcon: const Icon(
                              Icons.access_time,
                              color: AppTheme.textSecondaryColor,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: AppTheme.borderLightColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    label: const Text(
                      'Add Another Time',
                      style: TextStyle(color: AppTheme.primaryColor),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'FINISH',
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                        (route) => false,
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

  Widget _buildFeeRow(String title) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ),
        ),
        Container(width: 1, height: 50, color: AppTheme.borderLightColor),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                hintText: 'Input the fee',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
