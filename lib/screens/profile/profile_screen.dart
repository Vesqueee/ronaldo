import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session.dart';
import '../../theme/app_theme.dart';
import 'edit_profile_screen.dart';
import 'photo_picker_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  String _avatarUrl =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400';
  String _firstName = 'User';
  String _lastName = '';
  String _role = '';
  String _bio = '';
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = Session.currentUserId;
    if (userId == null) {
      setState(() {
        _errorMessage = 'Không tìm thấy người dùng. Vui lòng đăng nhập lại.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await ApiService.getProfile(userId);
      if (response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            _firstName = data['firstName'] ?? _firstName;
            _lastName = data['lastName'] ?? _lastName;
            _role = data['role'] ?? _role;
            _bio = data['bio'] ?? '';
            _phone = data['phone'] ?? '';
            _avatarUrl =
                data['avatarUrl'] != null &&
                    data['avatarUrl'].toString().isNotEmpty
                ? data['avatarUrl'] as String
                : _avatarUrl;
            _isLoading = false;
          });
          return;
        }
      }
      setState(() {
        _errorMessage = response['message'] ?? 'Không thể tải profile.';
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Lỗi kết nối. Vui lòng thử lại.';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAvatar() async {
    final String? selectedUrl = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const PhotoPickerScreen()),
    );

    if (selectedUrl == null) return;

    final userId = Session.currentUserId;
    final token = Session.currentToken;
    if (userId == null || token == null) {
      _showMessage('Bạn cần đăng nhập lại để thay đổi ảnh đại diện.');
      return;
    }

    try {
      final response = await ApiService.updateProfile(
        userId: userId,
        token: token,
        avatarUrl: selectedUrl,
      );
      if (response['success'] == true) {
        setState(() {
          _avatarUrl = selectedUrl;
        });
        _showMessage('Ảnh đại diện đã được cập nhật.');
      } else {
        _showMessage(response['message'] ?? 'Không thể cập nhật ảnh đại diện.');
      }
    } catch (_) {
      _showMessage('Lỗi kết nối khi cập nhật avatar.');
    }
  }

  Future<void> _openEditProfile() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          firstName: _firstName,
          lastName: _lastName,
          bio: _bio,
          phone: _phone,
          avatarUrl: _avatarUrl,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _firstName = result['firstName'] ?? _firstName;
        _lastName = result['lastName'] ?? _lastName;
        _bio = result['bio'] ?? _bio;
        _phone = result['phone'] ?? _phone;
        if (result['avatarUrl'] != null &&
            result['avatarUrl'].toString().isNotEmpty) {
          _avatarUrl = result['avatarUrl'] as String;
        }
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            SizedBox(
              height: 244,
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=800',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 160,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 24,
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Stack(
                        children: [
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                _avatarUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$_firstName $_lastName',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '127 Reviews',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Languages', onEdit: _openEditProfile),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 8,
                children: [
                  _buildChip('Vietnamese'),
                  _buildChip('English'),
                  _buildChip('Korean'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buildSectionHeader('Introduction', onEdit: _openEditProfile),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _bio.isNotEmpty
                    ? _bio
                    : 'Chưa có thông tin giới thiệu. Nhấn biểu tượng sửa để cập nhật.',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 16),

            if (_phone.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Phone: $_phone',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800',
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                    const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 48,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            _buildSectionHeader(
              'My Experiences',
              showArrow: true,
              onTap: () {
              },
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: Row(
                children: [
                  _buildExperienceCard(
                    '2 Hour Bicycle Tour exploring Hoi An',
                    'Hoi An, Vietnam',
                    'Jan 25, 2020',
                    '1234',
                    'https://images.unsplash.com/photo-1555412654-72a95a495858?w=400',
                  ),
                  const SizedBox(width: 16),
                  _buildExperienceCard(
                    'Food tour in Danang',
                    'Danang, Vietnam',
                    'Jan 20, 2020',
                    '234',
                    'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400',
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'SEE MORE',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            _buildReviewItem(
              'Pena Valdez',
              5,
              'Jan 22, 2020',
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s.',
              'https://i.pravatar.cc/150?img=32',
            ),
            _buildReviewItem(
              'Daebyun',
              4,
              'Jan 20, 2020',
              'Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for \'lorem ipsum\'',
              'https://i.pravatar.cc/150?img=44',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title, {
    VoidCallback? onEdit,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 16, 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            if (onEdit != null && !showArrow)
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                onPressed: onEdit,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            if (showArrow)
              const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondaryColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.borderLightColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.textSecondaryColor,
        ),
      ),
    );
  }

  Widget _buildExperienceCard(
    String title,
    String location,
    String date,
    String likes,
    String imageUrl,
  ) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderLightColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: AppTheme.primaryColor,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      likes,
                      style: const TextStyle(
                        color: AppTheme.textSecondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    String name,
    int rating,
    String date,
    String review,
    String imageUrl,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(
                    rating,
                    (index) =>
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  review,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
