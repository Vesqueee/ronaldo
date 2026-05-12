const express = require('express');
const jwt = require('jsonwebtoken');
const pool = require('../db');

const router = express.Router();

// Middleware để verify JWT token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

  if (!token) {
    return res.status(401).json({ success: false, message: 'Access token required.' });
  }

  jwt.verify(token, process.env.JWT_SECRET || 'replace_with_secret', (err, user) => {
    if (err) {
      return res.status(403).json({ success: false, message: 'Invalid token.' });
    }
    req.user = user; // user chứa { id, email }
    next();
  });
};

// GET /api/profile/:userId - Lấy profile của user
router.get('/profile/:userId', async (req, res) => {
  try {
    const { userId } = req.params;

    const [rows] = await pool.execute(
      'SELECT id, first_name, last_name, email, role, bio, phone, avatar_url, created_at FROM users WHERE id = ?',
      [userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'User not found.' });
    }

    const user = rows[0];
    return res.json({
      success: true,
      data: {
        id: user.id,
        firstName: user.first_name,
        lastName: user.last_name,
        email: user.email,
        role: user.role,
        bio: user.bio,
        phone: user.phone,
        avatarUrl: user.avatar_url,
        createdAt: user.created_at,
      },
    });
  } catch (error) {
    console.error('Get profile error:', error);
    return res.status(500).json({ success: false, message: 'Lỗi server khi lấy profile.' });
  }
});

// PUT /api/profile/:userId - Cập nhật profile (chỉ user đó mới được sửa)
router.put('/profile/:userId', authenticateToken, async (req, res) => {
  try {
    const { userId } = req.params;
    const { firstName, lastName, bio, phone, avatarUrl } = req.body;

    // Kiểm tra user chỉ sửa profile của mình
    if (req.user.id != userId) {
      return res.status(403).json({ success: false, message: 'Bạn chỉ có thể sửa profile của mình.' });
    }

    // Cập nhật fields được phép
    const updates = [];
    const params = [];

    if (firstName !== undefined) {
      updates.push('first_name = ?');
      params.push(firstName);
    }
    if (lastName !== undefined) {
      updates.push('last_name = ?');
      params.push(lastName);
    }
    if (bio !== undefined) {
      updates.push('bio = ?');
      params.push(bio);
    }
    if (phone !== undefined) {
      updates.push('phone = ?');
      params.push(phone);
    }
    if (avatarUrl !== undefined) {
      updates.push('avatar_url = ?');
      params.push(avatarUrl);
    }

    if (updates.length === 0) {
      return res.status(400).json({ success: false, message: 'Không có gì để cập nhật.' });
    }

    params.push(userId); // Thêm userId vào cuối params

    const sql = `UPDATE users SET ${updates.join(', ')} WHERE id = ?`;
    const [result] = await pool.execute(sql, params);

    if (result.affectedRows === 0) {
      return res.status(404).json({ success: false, message: 'User not found.' });
    }

    // Lấy profile đã cập nhật
    const [rows] = await pool.execute(
      'SELECT id, first_name, last_name, email, role, bio, phone, avatar_url FROM users WHERE id = ?',
      [userId]
    );

    const user = rows[0];
    return res.json({
      success: true,
      message: 'Cập nhật profile thành công.',
      data: {
        id: user.id,
        firstName: user.first_name,
        lastName: user.last_name,
        email: user.email,
        role: user.role,
        bio: user.bio,
        phone: user.phone,
        avatarUrl: user.avatar_url,
      },
    });
  } catch (error) {
    console.error('Update profile error:', error);
    return res.status(500).json({ success: false, message: 'Lỗi server khi cập nhật profile.' });
  }
});

module.exports = router;