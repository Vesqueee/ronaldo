-- Tạo database và bảng users cho đăng nhập/đăng ký
CREATE DATABASE IF NOT EXISTS flutter
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE flutter;

DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS conversations;
DROP TABLE IF EXISTS offers;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('traveler', 'guide') NOT NULL DEFAULT 'traveler',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE trips (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  duration VARCHAR(50),
  price DECIMAL(10,2),
  old_price DECIMAL(10,2),
  rating FLOAT DEFAULT 5.0,
  reviews_count INT DEFAULT 0,
  provider_name VARCHAR(255),
  itinerary TEXT,
  departure_date VARCHAR(100),
  departure_place VARCHAR(255),
  location VARCHAR(255),
  image_urls TEXT, -- Store as JSON or comma separated
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE trip_schedules (
  id INT AUTO_INCREMENT PRIMARY KEY,
  trip_id INT,
  day_number INT,
  time_label VARCHAR(50),
  description TEXT,
  FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE trip_prices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  trip_id INT,
  category VARCHAR(255),
  price_text VARCHAR(100),
  FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE offers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  sender_email VARCHAR(255) NOT NULL,
  fee DECIMAL(10,2) NOT NULL,
  offer_text TEXT NOT NULL,
  trip_title VARCHAR(255),
  trip_location VARCHAR(255),
  status ENUM('pending', 'accepted', 'rejected') NOT NULL DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Thêm user mẫu với mật khẩu đã hash bằng bcrypt
-- password gốc: 1234567890
INSERT INTO users (first_name, last_name, email, password_hash, role)
VALUES (
  'Test',
  'User',
  'user@test.com',
  '$2b$10$qgfr906uNfh.EfDmwK4vLO7YoKu3FpQ/xsf6oTc2SjoAXuPnC8zWu',
  'traveler'
);

-- Thêm user mẫu với mật khẩu đã hash bằng bcrypt
-- password gốc: 1234567890
INSERT INTO users (first_name, last_name, email, password_hash, role)
VALUES (
  'Guide',
  'Test',
  'guide@test.com',
  '$2b$10$qgfr906uNfh.EfDmwK4vLO7YoKu3FpQ/xsf6oTc2SjoAXuPnC8zWu',
  'guide'
);

-- Thêm user mẫu thứ 3
INSERT INTO users (first_name, last_name, email, password_hash, role)
VALUES (
  'Jonathan',
  'Parker',
  'jonathan@test.com',
  '$2b$10$qgfr906uNfh.EfDmwK4vLO7YoKu3FpQ/xsf6oTc2SjoAXuPnC8zWu',
  'guide'
);

-- Thêm trips mẫu
INSERT INTO trips (title, duration, price, old_price, rating, reviews_count, provider_name, itinerary, departure_date, departure_place, location, image_urls)
VALUES 
  ('Da Nang - Ba Na - Hoi An', '2 days, 2 nights', 400.00, 450.00, 5.0, 145, 'dulichviet', 'Da Nang - Ba Na - Hoi An', 'Feb 12', 'Ho Chi Minh', 'Danang, Vietnam', 'https://images.unsplash.com/photo-1559592413-7cea83781cb4?q=80&w=1000,https://images.unsplash.com/photo-1590132338140-5226c6d2e666?q=80&w=1000'),
  ('Dragon Bridge Trip', '1 day', 15.00, 20.00, 4.8, 50, 'DaNangTravel', 'Dragon Bridge - Han River', 'Jan 30', 'Da Nang', 'Da Nang, Vietnam', 'https://images.unsplash.com/photo-1559592413-7cea83781cb4?q=80&w=1000'),
  ('Ho Guom Trip', '1 day', 10.00, 15.00, 4.7, 30, 'HanoiTour', 'Ho Guom - Old Quarter', 'Feb 2', 'Hanoi', 'Hanoi, Vietnam', 'https://images.unsplash.com/photo-1590132338140-5226c6d2e666?q=80&w=1000'),
  ('Ho Chi Minh Mausoleum', '1 day', 20.00, 25.00, 4.9, 80, 'HanoiDiscovery', 'Mausoleum - One Pillar Pagoda', 'Feb 2', 'Hanoi', 'Hanoi, Vietnam', 'https://images.unsplash.com/photo-1590132338140-5226c6d2e666?q=80&w=1000'),
  ('Duc Ba Church', '1 day', 25.00, 30.00, 4.6, 40, 'SaigonLife', 'Duc Ba Church - Post Office', 'Feb 2', 'Ho Chi Minh', 'Ho Chi Minh, Vietnam', 'https://images.unsplash.com/photo-1559592413-7cea83781cb4?q=80&w=1000'),
  ('Quoc Tu Giam Temple', '1 day', 12.00, 18.00, 4.5, 25, 'CulturalHanoi', 'Quoc Tu Giam - Van Mieu', 'Feb 2', 'Hanoi', 'Hanoi, Vietnam', 'https://images.unsplash.com/photo-1590132338140-5226c6d2e666?q=80&w=1000'),
  ('Dinh Doc Lap', '1 day', 18.00, 22.00, 4.7, 60, 'SaigonHistory', 'Independence Palace', 'Feb 2', 'Ho Chi Minh', 'Ho Chi Minh, Vietnam', 'https://images.unsplash.com/photo-1559592413-7cea83781cb4?q=80&w=1000');

-- Thêm schedules cho các trip mới
INSERT INTO trip_schedules (trip_id, day_number, time_label, description)
VALUES 
  (1, 1, '6:00AM', 'Lorem Ipsum...'), (1, 1, '10:00AM', 'Lorem Ipsum...'),
  (2, 1, '8:00AM', 'Meeting at Dragon Bridge'), (2, 1, '10:00AM', 'Exploring Han River'),
  (3, 1, '8:00AM', 'Walking around Ho Guom'), (3, 1, '2:00PM', 'Visiting Old Quarter'),
  (4, 1, '7:00AM', 'Ho Chi Minh Mausoleum visit'), (4, 1, '11:00AM', 'One Pillar Pagoda'),
  (5, 1, '9:00AM', 'Duc Ba Church exploration'), (5, 1, '4:00PM', 'Saigon Post Office'),
  (6, 1, '8:30AM', 'Temple of Literature visit'),
  (7, 1, '1:30PM', 'Independence Palace tour');

-- Thêm prices cho các trip mới
INSERT INTO trip_prices (trip_id, category, price_text)
VALUES 
  (1, 'Adult (>10 years old)', '$400.00'), (1, 'Child', '$320.00'),
  (2, 'Adult', '$15.00'), (2, 'Child', '$10.00'),
  (3, 'Adult', '$10.00'), (3, 'Child', 'Free'),
  (4, 'Adult', '$20.00'), (4, 'Child', '$15.00'),
  (5, 'Adult', '$25.00'), (5, 'Child', '$20.00'),
  (6, 'Adult', '$12.00'), (6, 'Child', 'Free'),
  (7, 'Adult', '$18.00'), (7, 'Child', '$12.00');

-- Thêm offer mẫu
INSERT INTO offers (sender_email, fee, offer_text, trip_title, trip_location)
VALUES (
  'user@test.com',
  15.00,
  'I can show you the best food and hidden spots in Danang.',
  'Danang City Tour',
  'Danang, Vietnam'
);

-- Thêm columns cho profile management
ALTER TABLE users ADD COLUMN bio TEXT;
ALTER TABLE users ADD COLUMN phone VARCHAR(20);
ALTER TABLE users ADD COLUMN avatar_url VARCHAR(500);

-- Tạo bảng conversations
CREATE TABLE conversations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user1_email VARCHAR(255) NOT NULL,
  user2_email VARCHAR(255) NOT NULL,
  user1_name VARCHAR(200),
  user2_name VARCHAR(200),
  user1_avatar VARCHAR(500),
  user2_avatar VARCHAR(500),
  last_message TEXT,
  last_message_time TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_conversation (user1_email, user2_email),
  INDEX idx_user1 (user1_email),
  INDEX idx_user2 (user2_email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tạo bảng messages
CREATE TABLE messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  conversation_id INT NOT NULL,
  sender_email VARCHAR(255) NOT NULL,
  receiver_email VARCHAR(255) NOT NULL,
  content TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
  INDEX idx_conversation (conversation_id),
  INDEX idx_sender (sender_email),
  INDEX idx_receiver (receiver_email),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_email VARCHAR(255) NOT NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT,
  type VARCHAR(50) DEFAULT 'general',
  link VARCHAR(255),
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_user_email (user_email),
  INDEX idx_is_read (is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Thêm thông báo mẫu
INSERT INTO notifications (user_email, title, body, type, link, is_read, created_at)
VALUES
  ('user@test.com', 'Tin nhắn mới từ Guide Test', 'Xin chào! Tôi là hướng dẫn viên chuyên về tour Đà Nẵng', 'chat', '/chat/1', TRUE, DATE_SUB(NOW(), INTERVAL 5 DAY)),
  ('user@test.com', 'Tin nhắn mới từ Guide Test', 'Tuyệt vời! Tour của tôi bao gồm: Ba Na Hills, Hội An, và bãi biển Mỹ Khê', 'chat', '/chat/1', TRUE, DATE_SUB(NOW(), INTERVAL 4 DAY)),
  ('user@test.com', 'Tin nhắn mới từ jonathan@test.com', 'Tour 2 ngày có giá 350 USD. Chúng ta sẽ tham quan Bến Thành, Chinatown, và tòa nhà Bitexco', 'chat', '/chat/2', TRUE, DATE_SUB(NOW(), INTERVAL 22 HOUR)),
  ('user@test.com', 'Thông báo mới', 'Chúng tôi đã cập nhật lịch trình chuyến đi của bạn.', 'general', NULL, FALSE, DATE_SUB(NOW(), INTERVAL 1 HOUR));

-- Thêm cuộc trò chuyện mẫu 1
INSERT INTO conversations (user1_email, user2_email, user1_name, user2_name, user1_avatar, user2_avatar, last_message, last_message_time)
VALUES (
  'user@test.com',
  'guide@test.com',
  'Test User',
  'Guide Test',
  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200&auto=format&fit=crop',
  'Bạn có thể đưa tôi tham quan những địa điểm này không?',
  NOW()
);

-- Thêm tin nhắn mẫu cho cuộc trò chuyện 1
INSERT INTO messages (conversation_id, sender_email, receiver_email, content, is_read, created_at)
VALUES 
(1, 'guide@test.com', 'user@test.com', 'Xin chào! Tôi là hướng dẫn viên chuyên về tour Đà Nẵng', TRUE, DATE_SUB(NOW(), INTERVAL 5 DAY)),
(1, 'user@test.com', 'guide@test.com', 'Chào bạn! Tôi muốn đặt tour Đà Nẵng 3 ngày', FALSE, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(1, 'guide@test.com', 'user@test.com', 'Tuyệt vời! Tour của tôi bao gồm: Ba Na Hills, Hội An, và bãi biển Mỹ Khê', TRUE, DATE_SUB(NOW(), INTERVAL 4 DAY)),
(1, 'guide@test.com', 'user@test.com', 'Giá là 400 USD/người, bao gồm xe, hướng dẫn và ăn trưa', TRUE, DATE_SUB(NOW(), INTERVAL 3 DAY)),
(1, 'user@test.com', 'guide@test.com', 'Tuyệt quá! Bạn có thể đưa tôi tham quan những địa điểm này không?', FALSE, DATE_SUB(NOW(), INTERVAL 2 DAY));

-- Thêm cuộc trò chuyện mẫu 2  
INSERT INTO conversations (user1_email, user2_email, user1_name, user2_name, user1_avatar, user2_avatar, last_message, last_message_time)
VALUES (
  'user@test.com',
  'jonathan@test.com',
  'Test User',
  'Jonathan Parker',
  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=200&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200&auto=format&fit=crop',
  'Mình gặp nhau ở đâu ngày mai?',
  NOW()
);

-- Thêm tin nhắn mẫu cho cuộc trò chuyện 2
INSERT INTO messages (conversation_id, sender_email, receiver_email, content, is_read, created_at)
VALUES 
(2, 'user@test.com', 'jonathan@test.com', 'Chào! Bạn có thể hướng dẫn tour Hồ Chí Minh không?', TRUE, DATE_SUB(NOW(), INTERVAL 1 DAY)),
(2, 'jonathan@test.com', 'user@test.com', 'Có chứ! Tôi có tour 2 ngày ở Hồ Chí Minh rất tuyệt', TRUE, DATE_SUB(NOW(), INTERVAL 23 HOUR)),
(2, 'user@test.com', 'jonathan@test.com', 'Giá bao nhiêu vậy?', TRUE, DATE_SUB(NOW(), INTERVAL 23 HOUR)),
(2, 'jonathan@test.com', 'user@test.com', 'Tour 2 ngày có giá 350 USD. Chúng ta sẽ tham quan Bến Thành, Chinatown, và tòa nhà Bitexco', TRUE, DATE_SUB(NOW(), INTERVAL 22 HOUR)),
(2, 'jonathan@test.com', 'user@test.com', 'Mình gặp nhau ở đâu ngày mai?', FALSE, DATE_SUB(NOW(), INTERVAL 1 HOUR));
