const Pool = require("pg").Pool;
const db = new Pool({
    user: 'mobileadmin',
    host: 'localhost',
    database: 'mobileapp',
    password: 'password',
    port: 5432,
  });
  

module.exports = { db };

