const express = require('express');
const pool = require('../db');

const router = express.Router();

// Search trips
router.get('/search-trips', async (req, res) => {
  try {
    const query = req.query.q || '';
    const location = req.query.location || '';

    let sql = `SELECT id, title, duration, price, image_url, location FROM trips WHERE 1=1`;
    const params = [];

    if (location) {
      sql += ` AND location LIKE ?`;
      params.push(`%${location}%`);
    }

    if (query) {
      sql += ` AND title LIKE ?`;
      params.push(`%${query}%`);
    }

    sql += ` LIMIT 20`;

    const [rows] = await pool.execute(sql, params);

    return res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error('Search trips error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi server khi tìm kiếm trip.',
    });
  }
});

// Search guides
router.get('/search-guides', async (req, res) => {
  try {
    const query = req.query.q || '';
    const location = req.query.location || '';

    let sql = `SELECT u.id, u.email, u.first_name, u.last_name, u.role FROM users u WHERE u.role = 'guide'`;
    const params = [];

    if (location) {
      sql += ` AND (u.first_name LIKE ? OR u.last_name LIKE ?)`;
      params.push(`%${location}%`, `%${location}%`);
    }

    if (query) {
      sql += ` AND (u.first_name LIKE ? OR u.last_name LIKE ?)`;
      params.push(`%${query}%`, `%${query}%`);
    }

    sql += ` LIMIT 20`;

    const [rows] = await pool.execute(sql, params);

    return res.json({
      success: true,
      data: rows,
    });
  } catch (error) {
    console.error('Search guides error:', error);
    return res.status(500).json({
      success: false,
      message: 'Lỗi server khi tìm kiếm guide.',
    });
  }
});

module.exports = router;
