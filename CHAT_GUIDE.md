# Hướng Dẫn Sử Dụng Hệ Thống Chat

## 📱 Tính Năng Chat Mới

Bạn đã có hệ thống chat hoàn chỉnh với:

✅ **Nhắn tin thực tế** - Lưu trữ trong database
✅ **Danh sách cuộc trò chuyện** - Hiển thị tin nhắn cuối và thời gian
✅ **Tìm kiếm cuộc trò chuyện** - Tìm người hoặc nội dung tin nhắn
✅ **Giao diện chuyên nghiệp** - Hiển thị tin nhắn từng bên, avatar, thời gian

---

## 🔧 Thiết Lập Ban Đầu

### 1. Reset Database (Nếu chưa làm)
```bash
cd server
node reset_db.js
```

Điều này sẽ:
- Tạo bảng `conversations` và `messages`
- Thêm 2 user test: `user@test.com` và `guide@test.com`
- Password test: `1234567890`

### 2. Khởi Động Server
```bash
cd server
npm start
```

Server chạy trên: `http://localhost:3036`

---

## 🧪 Test Chat API

### A. Đăng Nhập
```bash
curl -X POST http://localhost:3036/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@test.com","password":"1234567890"}'
```

### B. Gửi Tin Nhắn
```bash
curl -X POST http://localhost:3036/api/send-message \
  -H "Content-Type: application/json" \
  -d '{
    "senderEmail":"user@test.com",
    "receiverEmail":"guide@test.com",
    "content":"Xin chào!"
  }'
```

### C. Lấy Danh Sách Cuộc Trò Chuyện
```bash
curl http://localhost:3036/api/conversations/user@test.com
```

### D. Lấy Tin Nhắn Trong Cuộc Trò Chuyện
```bash
# Thay <conversation_id> bằng ID thực từ bước C
curl http://localhost:3036/api/messages/<conversation_id>
```

---

## 📋 API Endpoints

| Phương Thức | Endpoint | Mô Tả |
|---|---|---|
| GET | `/api/conversations/:email` | Lấy danh sách cuộc trò chuyện |
| GET | `/api/messages/:conversationId` | Lấy tin nhắn trong cuộc trò chuyện |
| POST | `/api/send-message` | Gửi tin nhắn mới |
| PUT | `/api/mark-as-read/:conversationId` | Đánh dấu tin nhắn đã đọc |
| GET | `/api/search-conversations/:email` | Tìm kiếm cuộc trò chuyện |

---

## 📱 Cách Sử Dụng Trong Flutter

### 1. Đăng Nhập
- Email: `user@test.com`
- Password: `1234567890`

### 2. Vào Tab Chat
Bạn sẽ thấy danh sách cuộc trò chuyện của user (nếu có)

### 3. Tìm Kiếm
Nhập tên hoặc email người khác để tìm cuộc trò chuyện

### 4. Gửi Tin Nhắn
- Chọn cuộc trò chuyện
- Nhập nội dung
- Nhấn nút gửi (biểu tượng máy bay giấy)

---

## 🗄️ Cấu Trúc Database

### Bảng `conversations`
```sql
id                INT (PRIMARY KEY)
user1_email       VARCHAR
user2_email       VARCHAR
user1_name        VARCHAR
user2_name        VARCHAR
user1_avatar      VARCHAR
user2_avatar      VARCHAR
last_message      TEXT
last_message_time TIMESTAMP
created_at        TIMESTAMP
```

### Bảng `messages`
```sql
id                INT (PRIMARY KEY)
conversation_id   INT (FOREIGN KEY)
sender_email      VARCHAR
receiver_email    VARCHAR
content           TEXT
is_read           BOOLEAN
created_at        TIMESTAMP
```

---

## ⚙️ Troubleshooting

### Vấn đề: "Port 3036 already in use"
**Giải pháp**: Tìm process dùng port 3036 và kết thúc nó
```bash
# Windows
netstat -ano | findstr :3036
taskkill /PID <PID> /F

# macOS/Linux
lsof -i :3036
kill -9 <PID>
```

### Vấn đề: "Cannot find module 'mysql2'"
**Giải pháp**: Cài đặt dependencies
```bash
cd server
npm install
```

### Vấn đề: "Cannot connect to database"
**Giải pháp**: 
1. Kiểm tra MySQL server có chạy không
2. Kiểm tra credentials trong `.env`
3. Chạy `node reset_db.js` để khởi tạo database

---

## 🎨 Giao Diện Chat

- **Tin nhắn của bạn**: Màu xanh, bên phải
- **Tin nhắn người khác**: Màu xám, bên trái + avatar
- **Thời gian**: Hiển thị bên cạnh tin nhắn (nếu cùng người)
- **Search**: Tìm theo tên, email, hoặc nội dung tin nhắn

---

## 📝 File Được Sửa Đổi

1. **server/schema.sql** - Thêm bảng `conversations` và `messages`
2. **server/routes/chat.js** - API endpoints mới (tạo file)
3. **server/index.js** - Đăng ký route chat
4. **lib/services/api_service.dart** - Hàm gọi chat API
5. **lib/screens/chat/chat_screen.dart** - UI danh sách cuộc trò chuyện (cải tiến)
6. **lib/screens/chat/chat_detail_screen.dart** - UI cuộc trò chuyện chi tiết (cải tiến)

---

## 🚀 Tiếp Theo

Bạn có thể:
- Thêm upload ảnh/file
- Thêm typing indicator ("đang gõ...")
- Thêm voice message
- Thêm emoji reactions
- Thêm delete/edit tin nhắn
- Thêm real-time updates (Socket.io, WebSocket)

Hỏi tôi nếu muốn tìm thêm feature!
