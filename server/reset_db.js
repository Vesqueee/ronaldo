const mysql = require('mysql2/promise');
const fs = require('fs');

async function resetDatabase() {
  const connection = await mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
  });

  try {
    // Đọc file schema.sql
    const schema = fs.readFileSync('./schema.sql', 'utf8');
    
    // Chạy từng câu SQL
    const statements = schema.split(';').filter(s => s.trim());
    
    for (const statement of statements) {
      if (statement.trim()) {
        console.log('Running:', statement.substring(0, 50) + '...');
        await connection.query(statement);
      }
    }
    
    console.log('✅ Database reset successfully!');
    console.log('Sample data added: 7 trips, 1 offer');
  } catch (error) {
    console.error('❌ Error:', error.message);
  } finally {
    await connection.end();
  }
}

resetDatabase();
