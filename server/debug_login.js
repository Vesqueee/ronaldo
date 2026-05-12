const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');
require('dotenv').config();

async function debugLogin() {
  try {
    console.log('\n========== DATABASE DEBUG ==========\n');
    
    // Kiểm tra kết nối database
    const connection = await mysql.createConnection({
      host: process.env.DB_HOST || '127.0.0.1',
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'flutter',
    });
    
    console.log('✓ Kết nối database thành công');
    
    // Kiểm tra bảng users tồn tại không
    const [tables] = await connection.execute("SHOW TABLES LIKE 'users'");
    if (tables.length === 0) {
      console.log('✗ Bảng users không tồn tại. Hãy chạy schema.sql trước!');
      await connection.end();
      return;
    }
    console.log('✓ Bảng users tồn tại');
    
    // Lấy tất cả user
    const [users] = await connection.execute('SELECT id, email, first_name, last_name, role FROM users');
    console.log(`\n✓ Tất cả users trong database (${users.length} users):`);
    users.forEach((user, index) => {
      console.log(`  ${index + 1}. ${user.email} - ${user.first_name} ${user.last_name} (${user.role})`);
    });
    
    if (users.length === 0) {
      console.log('  ✗ Không có user nào. Hãy chạy schema.sql để thêm dữ liệu test!');
    }
    
    // Test đăng nhập với user test
    console.log('\n========== TEST LOGIN ==========\n');
    
    const testEmail = 'user@test.com';
    const testPassword = '1234567890';
    
    console.log(`Đang test login với email: ${testEmail}`);
    
    const [rows] = await connection.execute('SELECT * FROM users WHERE email = ?', [testEmail]);
    
    if (rows.length === 0) {
      console.log(`✗ User ${testEmail} không tồn tại trong database`);
    } else {
      const user = rows[0];
      console.log(`✓ Tìm thấy user: ${user.first_name} ${user.last_name}`);
      
      // Test password
      const isValid = await bcrypt.compare(testPassword, user.password_hash);
      if (isValid) {
        console.log(`✓ Password chính xác!`);
      } else {
        console.log(`✗ Password không khớp!`);
        console.log(`  Hash lưu trong DB: ${user.password_hash}`);
      }
    }
    
    await connection.end();
    console.log('\n✓ Debug hoàn tất\n');
    
  } catch (error) {
    console.error('✗ Lỗi:', error.message);
    console.log('\nHãy kiểm tra:');
    console.log('1. MySQL server có chạy không?');
    console.log('2. Database credentials trong .env có đúng không?');
    console.log('3. Database "flutter" đã được tạo chưa?');
  }
}

debugLogin();
