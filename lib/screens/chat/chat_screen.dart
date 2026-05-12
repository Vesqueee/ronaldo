import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session.dart';
import '../../theme/app_theme.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, dynamic>> _conversations = [];
  List<Map<String, dynamic>> _filteredConversations = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConversations();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadConversations() async {
    if (Session.currentEmail == null) return;

    setState(() => _isLoading = true);
    try {
      final response =
          await ApiService.getConversations(Session.currentEmail!);

      if (response['success'] == true) {
        setState(() {
          _conversations = List<Map<String, dynamic>>.from(
            response['data'] ?? [],
          );
          _filteredConversations = _conversations;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải cuộc trò chuyện: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() => _searchQuery = query);

    if (query.isEmpty) {
      setState(() => _filteredConversations = _conversations);
    } else {
      setState(() {
        _filteredConversations = _conversations.where((conv) {
          final name = (conv['otherName'] ?? '').toLowerCase();
          final email = (conv['otherEmail'] ?? '').toLowerCase();
          final message = (conv['lastMessage'] ?? '').toLowerCase();
          final queryLower = query.toLowerCase();

          return name.contains(queryLower) ||
              email.contains(queryLower) ||
              message.contains(queryLower);
        }).toList();
      });
    }
  }

  String _formatTime(dynamic dateTime) {
    if (dateTime == null) return '';

    try {
      final DateTime time = dateTime is DateTime
          ? dateTime
          : DateTime.parse(dateTime.toString());
      final DateTime now = DateTime.now();
      final Duration difference = now.difference(time);

      if (difference.inDays == 0) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      } else if (difference.inDays == 1) {
        return 'Hôm qua';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} ngày trước';
      } else {
        return '${time.day}/${time.month}';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header
          _buildHeader(),
          // Search bar
          _buildSearchBar(),
          // Conversations list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                : _filteredConversations.isEmpty
                    ? _buildEmptyState()
                    : _buildConversationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
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
                'Messages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _loadConversations,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm cuộc trò chuyện...',
          hintStyle: const TextStyle(color: AppTheme.textSecondaryColor),
          prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondaryColor),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.textSecondaryColor),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppTheme.primaryColor),
          ),
          filled: true,
          fillColor: const Color(0xFFF8F8F8),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildConversationsList() {
    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: _loadConversations,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _filteredConversations.length,
        itemBuilder: (context, index) {
          final conversation = _filteredConversations[index];
          return _buildConversationItem(context, conversation);
        },
      ),
    );
  }

  Widget _buildConversationItem(
    BuildContext context,
    Map<String, dynamic> conversation,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              conversationId: conversation['id'],
              otherEmail: conversation['otherEmail'],
              otherName: conversation['otherName'] ?? 'Unknown',
              otherAvatar: conversation['otherAvatar'] ?? '',
            ),
          ),
        ).then((_) => _loadConversations());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryColor.withOpacity(0.1),
              ),
              child: CircleAvatar(
                backgroundImage: conversation['otherAvatar'] != null &&
                        (conversation['otherAvatar'] as String).isNotEmpty
                    ? NetworkImage(conversation['otherAvatar'])
                    : null,
                child: conversation['otherAvatar'] == null ||
                        (conversation['otherAvatar'] as String).isEmpty
                    ? Text(
                        (conversation['otherName'] ?? 'U')[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Message info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation['otherName'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation['lastMessage'] ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Time
            Text(
              _formatTime(conversation['lastMessageTime']),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: AppTheme.primaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'Chưa có cuộc trò chuyện'
                : 'Không tìm thấy kết quả',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Hãy bắt đầu cuộc hội thoại mới'
                : 'Thử tìm kiếm với từ khóa khác',
            style: const TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
