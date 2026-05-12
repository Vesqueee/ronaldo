import 'package:flutter/material.dart';

import '../../services/api_service.dart';
import '../../services/session.dart';
import '../../theme/app_theme.dart';

class ChatDetailScreen extends StatefulWidget {
  final int conversationId;
  final String otherEmail;
  final String otherName;
  final String otherAvatar;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.otherEmail,
    required this.otherName,
    required this.otherAvatar,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

// ✅ Chỉ khai báo Message 1 LẦN duy nhất
class Message {
  final int id;
  final String senderEmail;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  Message({
    required this.id,
    required this.senderEmail,
    required this.content,
    required this.createdAt,
    required this.isRead,
  });

  bool get isMe => senderEmail == Session.currentEmail;
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _markAsRead();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      final response = await ApiService.getMessages(widget.conversationId);

      if (response['success'] == true) {
        final messagesData = response['data'] as List<dynamic>;
        setState(() {
          _messages = messagesData
              .map((msg) {
                final dynamic isReadRaw = msg['is_read'];
                final bool isReadValue = isReadRaw is bool
                    ? isReadRaw
                    : isReadRaw is int
                        ? isReadRaw == 1
                        : false;
                return Message(
                  id: msg['id'] ?? 0,
                  senderEmail: msg['sender_email'] ?? '',
                  content: msg['content'] ?? '',
                  createdAt: msg['created_at'] is DateTime
                      ? msg['created_at']
                      : DateTime.parse(msg['created_at'].toString()),
                  isRead: isReadValue,
                );
              })
              .toList();
        });
        _scrollToBottom();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Lỗi tải tin nhắn'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải tin nhắn: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _markAsRead() async {
    try {
      if (Session.currentEmail == null) return;
      await ApiService.markAsRead(
        conversationId: widget.conversationId,
        receiverEmail: Session.currentEmail!,
      );
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty || Session.currentEmail == null) return;

    setState(() => _isSending = true);
    _messageController.clear();

    try {
      final response = await ApiService.sendMessage(
        senderEmail: Session.currentEmail!,
        receiverEmail: widget.otherEmail,
        content: content,
      );

      if (response['success'] == true) {
        final newMessage = Message(
          id: response['data']?['id'] ?? 0,
          senderEmail: Session.currentEmail!,
          content: content,
          createdAt: DateTime.now(),
          isRead: false,
        );
        setState(() {
          _messages.add(newMessage);
        });
        _scrollToBottom();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Lỗi gửi tin nhắn'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
    return '${dateTime.day}/${dateTime.month}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryColor,
                    ),
                  )
                : _messages.isEmpty
                    ? _buildEmptyChat()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final prevMsg =
                              index > 0 ? _messages[index - 1] : null;
                          final showHeader = prevMsg == null ||
                              prevMsg.senderEmail != msg.senderEmail;
                          return _buildMessageItem(msg, showHeader);
                        },
                      ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
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
          const Text(
            'Chưa có tin nhắn',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hãy bắt đầu cuộc trò chuyện',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.otherName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.otherEmail,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: AppTheme.primaryColor),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageItem(Message msg, bool showHeader) {
    if (msg.isMe) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (showHeader)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _formatTime(msg.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(4),
                      ),
                    ),
                    child: Text(
                      msg.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader)
              CircleAvatar(
                radius: 18,
                backgroundImage: widget.otherAvatar.isNotEmpty
                    ? NetworkImage(widget.otherAvatar)
                    : null,
                child: widget.otherAvatar.isEmpty
                    ? Text(
                        widget.otherName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              )
            else
              const SizedBox(width: 36),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        _formatTime(msg.createdAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: Text(
                        msg.content,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE8E8E8), width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                ),
                child: TextField(
                  controller: _messageController,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _isSending ? null : (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    hintStyle: TextStyle(
                      color: AppTheme.textSecondaryColor,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _isSending ? null : _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _isSending
                      ? AppTheme.primaryColor.withOpacity(0.5)
                      : AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: _isSending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}