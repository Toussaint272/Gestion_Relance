// backend/createHash.js
const bcrypt = require('bcrypt');

async function createHash() {
  const password = 'admin123'; // ovay eto raha tianao mot de passe hafa
  const hash = await bcrypt.hash(password, 10);
  console.log('Plain password:', password);
  console.log('Bcrypt hash (copier this to DB):');
  console.log(hash);
}

createHash().catch(err => console.error(err));
