const bcrypt = require('bcrypt');

async function hashPassword() {
  const password = 'password123';
  const hash = await bcrypt.hash(password, 10);
  console.log('Password: ' + password);
  console.log('Hash: ' + hash);
  console.log('\nSQL Command:');
  console.log(`UPDATE users SET password_hash = '${hash}' WHERE email = 'user@test.com';`);
}

hashPassword();
