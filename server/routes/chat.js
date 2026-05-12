const express = require('express');
const pool = require('../db');

const router = express.Router();

// Lấy danh sách cuộc trò chuyện của user
router.get('/conversations/:email', async (req, res) => {
  try {
    const { email } = req.params;
    
    const [conversations] = await pool.execute(
      `SELECT * FROM conversations 
       WHERE user1_email = ? OR user2_email = ?
       ORDER BY last_message_time DESC`,
      [email, email]
    );

    // Format lại dữ liệu để dễ sử dụng
    const formattedConversations = conversations.map(conv => {
      const isUser1 = conv.user1_email === email;
      return {
        id: conv.id,
        otherEmail: isUser1 ? conv.user2_email : conv.user1_email,
        otherName: isUser1 ? conv.user2_name : conv.user1_name,
        otherAvatar: isUser1 ? conv.user2_avatar : conv.user1_avatar,
        lastMessage: conv.last_message,
        lastMessageTime: conv.last_message_time,
        createdAt: conv.created_at,
      };
    });

    return res.json({
      success: true,
      data: formattedConversations,
    });
  } catch (error) {
    console.error('Get conversations error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy danh sách cuộc trò chuyện',
    });
  }
});

// Lấy messages trong một cuộc trò chuyện
router.get('/messages/:conversationId', async (req, res) => {
  try {
    const { conversationId } = req.params;
    const { limit = 50, offset = 0 } = req.query;

    const [messages] = await pool.execute(
      `SELECT id, sender_email, receiver_email, content, is_read, created_at
       FROM messages
       WHERE conversation_id = ?
       ORDER BY created_at DESC
       LIMIT ? OFFSET ?`,
      [conversationId, parseInt(limit), parseInt(offset)]
    );

    // Đảo ngược để hiển thị theo thứ tự thời gian tăng dần
    messages.reverse();

    return res.json({
      success: true,
      data: messages,
    });
  } catch (error) {
    console.error('Get messages error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy tin nhắn',
    });
  }
});

// Gửi tin nhắn
router.post('/send-message', async (req, res) => {
  try {
    const { senderEmail, receiverEmail, content } = req.body;

    if (!senderEmail || !receiverEmail || !content) {
      return res.status(400).json({
        success: false,
        message: 'Thông tin không đầy đủ',
      });
    }

    if (content.trim().length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Nội dung tin nhắn không được trống',
      });
    }

    // Lấy thông tin sender
    const [senderRows] = await pool.execute(
      'SELECT first_name, last_name, avatar_url FROM users WHERE email = ?',
      [senderEmail]
    );

    // Lấy thông tin receiver
    const [receiverRows] = await pool.execute(
      'SELECT first_name, last_name, avatar_url FROM users WHERE email = ?',
      [receiverEmail]
    );

    if (senderRows.length === 0 || receiverRows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Người dùng không tồn tại',
      });
    }

    const senderName = `${senderRows[0].first_name} ${senderRows[0].last_name}`;
    const senderAvatar = senderRows[0].avatar_url;
    const receiverName = `${receiverRows[0].first_name} ${receiverRows[0].last_name}`;
    const receiverAvatar = receiverRows[0].avatar_url;

    // Kiểm tra xem conversation đã tồn tại chưa
    let [conversations] = await pool.execute(
      `SELECT id FROM conversations 
       WHERE (user1_email = ? AND user2_email = ?) 
          OR (user1_email = ? AND user2_email = ?)`,
      [senderEmail, receiverEmail, receiverEmail, senderEmail]
    );

    let conversationId;

    if (conversations.length === 0) {
      // Tạo conversation mới
      const [result] = await pool.execute(
        `INSERT INTO conversations 
         (user1_email, user2_email, user1_name, user2_name, user1_avatar, user2_avatar, last_message, last_message_time)
         VALUES (?, ?, ?, ?, ?, ?, ?, NOW())`,
        [senderEmail, receiverEmail, senderName, receiverName, senderAvatar, receiverAvatar, content]
      );
      conversationId = result.insertId;
    } else {
      conversationId = conversations[0].id;
      // Update last_message
      await pool.execute(
        `UPDATE conversations SET last_message = ?, last_message_time = NOW() WHERE id = ?`,
        [content, conversationId]
      );
    }

    // Thêm message
    const [messageResult] = await pool.execute(
      `INSERT INTO messages (conversation_id, sender_email, receiver_email, content, is_read)
       VALUES (?, ?, ?, ?, FALSE)`,
      [conversationId, senderEmail, receiverEmail, content]
    );

    // Tạo thông báo cho người nhận
    await pool.execute(
      `INSERT INTO notifications (user_email, title, body, type, link, is_read)
       VALUES (?, ?, ?, 'chat', ?, FALSE)`,
      [
        receiverEmail,
        `Tin nhắn mới từ ${senderName}`,
        content,
        `/chat/${conversationId}`,
      ]
    );

    return res.json({
      success: true,
      message: 'Tin nhắn đã được gửi',
      data: {
        id: messageResult.insertId,
        conversationId,
        senderEmail,
        receiverEmail,
        content,
        isRead: false,
        createdAt: new Date().toISOString(),
      },
    });
  } catch (error) {
    console.error('Send message error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi khi gửi tin nhắn',
    });
  }
});

// Đánh dấu tin nhắn đã đọc
router.put('/mark-as-read/:conversationId', async (req, res) => {
  try {
    const { conversationId } = req.params;
    const { receiverEmail } = req.body;

    if (!receiverEmail) {
      return res.status(400).json({
        success: false,
        message: 'Email nhận không được để trống',
      });
    }

    await pool.execute(
      `UPDATE messages SET is_read = TRUE 
       WHERE conversation_id = ? AND receiver_email = ? AND is_read = FALSE`,
      [conversationId, receiverEmail]
    );

    return res.json({
      success: true,
      message: 'Đã đánh dấu tin nhắn đã đọc',
    });
  } catch (error) {
    console.error('Mark as read error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi khi đánh dấu tin nhắn',
    });
  }
});

// Tìm kiếm cuộc trò chuyện
router.get('/search-conversations/:email', async (req, res) => {
  try {
    const { email } = req.params;
    const { query } = req.query;

    if (!query || query.trim().length === 0) {
      return res.json({
        success: true,
        data: [],
      });
    }

    const searchTerm = `%${query}%`;

    const [conversations] = await pool.execute(
      `SELECT * FROM conversations 
       WHERE (user1_email = ? OR user2_email = ?)
       AND (user1_name LIKE ? OR user2_name LIKE ? OR user1_email LIKE ? OR user2_email LIKE ?)
       ORDER BY last_message_time DESC`,
      [email, email, searchTerm, searchTerm, searchTerm, searchTerm]
    );

    const formattedConversations = conversations.map(conv => {
      const isUser1 = conv.user1_email === email;
      return {
        id: conv.id,
        otherEmail: isUser1 ? conv.user2_email : conv.user1_email,
        otherName: isUser1 ? conv.user2_name : conv.user1_name,
        otherAvatar: isUser1 ? conv.user2_avatar : conv.user1_avatar,
        lastMessage: conv.last_message,
        lastMessageTime: conv.last_message_time,
      };
    });

    return res.json({
      success: true,
      data: formattedConversations,
    });
  } catch (error) {
    console.error('Search conversations error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi khi tìm kiếm',
    });
  }
});

module.exports = router;
