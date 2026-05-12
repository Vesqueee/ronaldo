const express = require('express');
const pool = require('../db');

const router = express.Router();

// Lấy danh sách thông báo cho user
router.get('/notifications/:email', async (req, res) => {
  try {
    const { email } = req.params;
    const [notifications] = await pool.execute(
      `SELECT id, title, body, type, link, is_read, created_at
       FROM notifications
       WHERE user_email = ?
       ORDER BY created_at DESC`,
      [email]
    );

    return res.json({
      success: true,
      data: notifications,
    });
  } catch (error) {
    console.error('Get notifications error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông báo',
    });
  }
});

router.get('/notifications', async (req, res) => {
  try {
    const { email } = req.query;
    if (!email) {
      return res.status(400).json({
        success: false,
        message: 'Email thông báo không được để trống',
      });
    }
    const [notifications] = await pool.execute(
      `SELECT id, title, body, type, link, is_read, created_at
       FROM notifications
       WHERE user_email = ?
       ORDER BY created_at DESC`,
      [email]
    );

    return res.json({
      success: true,
      data: notifications,
    });
  } catch (error) {
    console.error('Get notifications by query error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi khi lấy thông báo',
    });
  }
});

// Đánh dấu một thông báo đã đọc
router.put('/notifications/:id/read', async (req, res) => {
  try {
    const { id } = req.params;

    const [result] = await pool.execute(
      'UPDATE notifications SET is_read = TRUE WHERE id = ?',
      [id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({
        success: false,
        message: 'Không tìm thấy thông báo',
      });
    }

    return res.json({
      success: true,
      message: 'Đã đánh dấu thông báo đã đọc',
    });
  } catch (error) {
    console.error('Mark notification as read error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi khi cập nhật thông báo',
    });
  }
});

module.exports = router;
