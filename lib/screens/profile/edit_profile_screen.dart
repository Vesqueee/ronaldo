import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/api_service.dart';
import '../../services/session.dart';
import 'photo_picker_screen.dart';

class EditProfileScreen extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? phone;
  final String? avatarUrl;

  const EditProfileScreen({
    super.key,
    this.firstName,
    this.lastName,
    this.bio,
    this.phone,
    this.avatarUrl,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _bioController;
  late final TextEditingController _phoneController;
  String _avatarUrl = 'https://i.pravatar.cc/150?img=11';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName ?? '');
    _lastNameController = TextEditingController(text: widget.lastName ?? '');
    _bioController = TextEditingController(text: widget.bio ?? '');
    _phoneController = TextEditingController(text: widget.phone ?? '');
    _avatarUrl = widget.avatarUrl ?? _avatarUrl;

    if (widget.firstName == null ||
        widget.lastName == null ||
        widget.bio == null ||
        widget.phone == null) {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    final userId = Session.currentUserId;
    if (userId == null) return;

    setState(() => _loading = true);
    try {
      final response = await ApiService.getProfile(userId);
      if (response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null) {
          _firstNameController.text = data['firstName'] ?? '';
          _lastNameController.text = data['lastName'] ?? '';
          _bioController.text = data['bio'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          if (data['avatarUrl'] != null &&
              data['avatarUrl'].toString().isNotEmpty) {
            _avatarUrl = data['avatarUrl'] as String;
          }
        }
      }
    } catch (_) {
      // Không cần hiển thị lỗi nếu load profile thất bại.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveProfile() async {
    final userId = Session.currentUserId;
    final token = Session.currentToken;
    if (userId == null || token == null) {
      _showMessage('Bạn cần đăng nhập lại để lưu profile.');
      return;
    }

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final bio = _bioController.text.trim();
    final phone = _phoneController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty) {
      _showMessage('Vui lòng nhập họ và tên.');
      return;
    }

    setState(() => _loading = true);
    try {
      final response = await ApiService.updateProfile(
        userId: userId,
        token: token,
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        phone: phone,
        avatarUrl: _avatarUrl,
      );
      if (!mounted) return;
      if (response['success'] == true) {
        final updated = response['data'] as Map<String, dynamic>?;
        Navigator.pop(context, updated);
        return;
      }
      _showMessage(response['message'] ?? 'Cập nhật profile thất bại.');
    } catch (_) {
      if (!mounted) return;
      _showMessage('Lỗi kết nối khi lưu profile.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickAvatar() async {
    final String? selectedUrl = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const PhotoPickerScreen()),
    );
    if (selectedUrl != null) {
      setState(() {
        _avatarUrl = selectedUrl;
      });
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
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
          'Edit Profile',
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
            onPressed: _loading ? null : _saveProfile,
            child: Text(
              'SAVE',
              style: TextStyle(
                color: _loading
                    ? AppTheme.textSecondaryColor
                    : AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: _pickAvatar,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(_avatarUrl),
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
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildTextField('First name', _firstNameController),
                  const SizedBox(height: 24),
                  _buildTextField('Last name', _lastNameController),
                  const SizedBox(height: 24),
                  _buildTextField(
                    'Phone number',
                    _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  _buildTextField('Introduction', _bioController, maxLines: 4),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: const InputDecoration(
            hintText: '',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.borderLightColor),
            ),
          ),
        ),
      ],
    );
  }
}
