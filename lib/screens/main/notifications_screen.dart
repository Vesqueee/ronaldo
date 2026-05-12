import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session.dart';
import '../../theme/app_theme.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final email = Session.currentEmail;
    if (email == null) {
      setState(() {
        _error = 'Không tìm thấy người dùng hiện tại.';
        _loading = false;
      });
      return;
    }

    try {
      final response = await ApiService.getNotifications(email);
      if (response['success'] == true && response['data'] is List) {
        setState(() {
          _notifications = List<Map<String, dynamic>>.from(response['data']);
          _loading = false;
        });
      } else {
        setState(() {
          _error = response['message']?.toString() ?? 'Lỗi khi tải thông báo.';
          _loading = false;
        });
      }
    } catch (error) {
      setState(() {
        _error = 'Lỗi khi kết nối tới server: ${error.toString()}';
        _loading = false;
      });
      if (kDebugMode) {
        print('Notifications load error: $error');
      }
    }
  }

  Future<void> _markAsRead(int id) async {
    try {
      final response = await ApiService.markNotificationAsRead(id);
      if (response['success'] == true) {
        setState(() {
          final index = _notifications.indexWhere((item) => item['id'] == id);
          if (index != -1) {
            _notifications[index]['is_read'] = true;
          }
        });
      }
    } catch (error) {
      // ignore errors silently for now
    }
  }

  Widget _buildNotificationIcon(String type) {
    switch (type) {
      case 'chat':
        return const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 12);
      case 'offer':
        return const Icon(Icons.attach_money, color: Colors.white, size: 12);
      default:
        return const Icon(Icons.notifications, color: Colors.white, size: 12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=800&auto=format&fit=crop',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.3)],
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 20,
                right: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: _loadNotifications,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              transform: Matrix4.translationValues(0.0, -20.0, 0.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppTheme.textSecondaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        )
                      : _notifications.isEmpty
                          ? const Center(
                              child: Text(
                                'Không có thông báo mới.',
                                style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadNotifications,
                              child: ListView.separated(
                                padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 24),
                                itemCount: _notifications.length,
                                separatorBuilder: (context, index) => const Divider(
                                  height: 32,
                                  thickness: 1,
                                  color: Color(0xFFF1F1F1),
                                ),
                                itemBuilder: (context, index) {
                                  final item = _notifications[index];
                                  final bool isRead = item['is_read'] is bool
                                      ? item['is_read']
                                      : item['is_read'] is int
                                          ? item['is_read'] == 1
                                          : false;
                                  final String title = item['title']?.toString() ?? '';
                                  final String body = item['body']?.toString() ?? '';
                                  final String time = item['created_at']?.toString() ?? '';
                                  final String type = item['type']?.toString() ?? 'general';

                                  return InkWell(
                                    onTap: () {
                                      if (!isRead) {
                                        _markAsRead(item['id'] as int);
                                      }
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            CircleAvatar(
                                              radius: 24,
                                              backgroundColor: AppTheme.primaryColor,
                                              child: _buildNotificationIcon(type),
                                            ),
                                            if (!isRead)
                                              Positioned(
                                                right: -2,
                                                bottom: -2,
                                                child: Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                title,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppTheme.textPrimaryColor,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                body,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: AppTheme.textSecondaryColor,
                                                  height: 1.4,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                time,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: AppTheme.textSecondaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
