require('dotenv').config();
const express = require('express');
const cors = require('cors');
const authRoutes = require('./routes/auth');
const searchRoutes = require('./routes/search');
const profileRoutes = require('./routes/profile');
const chatRoutes = require('./routes/chat');
const notificationRoutes = require('./routes/notifications');
const tripRoutes = require('./routes/trips');

const app = express();
const port = process.env.PORT || 3036;

app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
  console.log(`[${new Date().toLocaleTimeString()}] ${req.method} ${req.path}`);
  next();
});

app.get('/', (req, res) => {
  res.json({ success: true, message: 'API đăng nhập/đăng ký đã sẵn sàng.' });
});

app.get('/api', (req, res) => {
  res.json({ success: true, message: 'API base endpoint is active. Use /api/login, /api/register or /api/send-offer.' });
});

app.use('/api', authRoutes);
app.use('/api', searchRoutes);
app.use('/api', profileRoutes);
app.use('/api', chatRoutes);
app.use('/api', notificationRoutes);
app.use('/api/trips', tripRoutes);

const server = app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});

server.on('error', (error) => {
  if (error.code === 'EADDRINUSE') {
    console.error(`Port ${port} is already in use. Please stop the process using that port or set PORT to a different value.`);
  } else {
    console.error('Server error:', error);
  }
  process.exit(1);
});
