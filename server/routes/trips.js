const express = require('express');
const router = express.Router();
const db = require('../db');

// Get trip detail by ID
router.get('/:id', async (req, res) => {
  const tripId = req.params.id;

  try {
    // Get basic trip info
    const [trips] = await db.execute('SELECT * FROM trips WHERE id = ?', [tripId]);
    
    if (trips.length === 0) {
      return res.status(404).json({ message: 'Trip not found' });
    }

    const trip = trips[0];

    // Get schedules
    const [schedules] = await db.execute(
      'SELECT * FROM trip_schedules WHERE trip_id = ? ORDER BY day_number ASC, id ASC',
      [tripId]
    );

    // Get prices
    const [prices] = await db.execute(
      'SELECT * FROM trip_prices WHERE trip_id = ?',
      [tripId]
    );

    // Format output
    const result = {
      ...trip,
      schedules: schedules.reduce((acc, curr) => {
        const dayKey = `Day ${curr.day_number}`;
        if (!acc[dayKey]) acc[dayKey] = [];
        acc[dayKey].push({
          time: curr.time_label,
          description: curr.description
        });
        return acc;
      }, {}),
      prices: prices.map(p => ({
        category: p.category,
        price: p.price_text
      }))
    };

    res.json(result);
  } catch (error) {
    console.error('Error fetching trip details:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});

module.exports = router;
