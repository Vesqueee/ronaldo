import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../services/session.dart';
import 'edit_profile_screen.dart';
import '../auth/sign_in_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _firstName = 'User';
  String _lastName = '';
  String _role = '';
  String _avatarUrl = 'https://i.pravatar.cc/150?img=11';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = Session.currentUserId;
    if (userId == null) {
      return;
    }

    try {
      final response = await ApiService.getProfile(userId);
      if (response['success'] == true && mounted) {
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            _firstName = data['firstName'] ?? _firstName;
            _lastName = data['lastName'] ?? _lastName;
            _role = data['role'] ?? _role;
            _avatarUrl =
                (data['avatarUrl'] != null &&
                    data['avatarUrl'].toString().isNotEmpty)
                ? data['avatarUrl'] as String
                : _avatarUrl;
          });
        }
      }
    } catch (e) {
      // Silently handle error during profile load
    }
  }

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
          'Settings',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // User Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(_avatarUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$_firstName $_lastName'.trim(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _role.isNotEmpty ? _role : 'User',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              firstName: _firstName,
                              lastName: _lastName,
                              avatarUrl: _avatarUrl,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'EDIT PROFILE',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Settings List
            _buildSettingItem(
              Icons.notifications_none,
              'Notifications',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeThumbColor: AppTheme.primaryColor,
              ),
            ),
            _buildSettingItem(Icons.language, 'Languages'),
            _buildSettingItem(Icons.payment, 'Payment info'),
            _buildSettingItem(Icons.insert_chart_outlined, 'Income Stats'),
            _buildSettingItem(Icons.policy_outlined, 'Privacy & Policies'),
            _buildSettingItem(Icons.feedback_outlined, 'Feedback'),
            _buildSettingItem(Icons.info_outline, 'Usage'),

            const SizedBox(height: 48),

            // Sign out
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Sign out',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, {Widget? trailing}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.borderLightColor, width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: AppTheme.textSecondaryColor),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        trailing:
            trailing ??
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondaryColor,
              size: 20,
            ),
        onTap: trailing == null ? () {} : null,
      ),
    );
  }
}
