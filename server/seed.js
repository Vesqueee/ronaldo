const bcrypt = require('bcrypt');
const pool = require('./db');

async function seedUser() {
  try {
    const email = 'user@test.com';
    const password = '1234567890';
    const firstName = 'Test';
    const lastName = 'User';
    const role = 'traveler';

    const passwordHash = await bcrypt.hash(password, 10);

    const [existing] = await pool.execute('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      await pool.execute(
        'UPDATE users SET first_name = ?, last_name = ?, password_hash = ?, role = ? WHERE email = ?',
        [firstName, lastName, passwordHash, role, email]
      );
      console.log('✓ User updated successfully');
    } else {
      await pool.execute(
        'INSERT INTO users (first_name, last_name, email, password_hash, role) VALUES (?, ?, ?, ?, ?)',
        [firstName, lastName, email, passwordHash, role]
      );
      console.log('✓ User created successfully');
    }

    console.log('Email:', email);
    console.log('Password:', password);
    console.log('Role:', role);
    process.exit(0);
  } catch (error) {
    console.error('Error:', error.message);
    process.exit(1);
  }
}

seedUser();
