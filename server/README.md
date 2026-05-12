# API Đăng nhập / Đăng ký cho flutter

API này cung cấp hai endpoint cơ bản:

- `POST /api/register` - đăng ký người dùng mới
- `POST /api/sign_up` - đăng ký người dùng mới (alias)
- `POST /api/login` - đăng nhập

## Cài đặt

1. Vào thư mục `server`
2. Chạy `npm install`
3. Copy file `.env.example` thành `.env`
4. Sửa thông tin kết nối MySQL trong `.env`

## Khởi chạy

- `npm start`

## Cấu trúc database

Tạo bảng bằng `server/schema.sql`.

## Gợi ý body

### Đăng ký
POST /api/register
{
  "firstName": "Tuan",
  "lastName": "Tran",
  "email": "tuan.tran@gmail.com",
  "password": "123456",
  "role": "traveler"
}

### Đăng nhập
POST /api/login
{
  "email": "tuan.tran@gmail.com",
  "password": "123456"
}
