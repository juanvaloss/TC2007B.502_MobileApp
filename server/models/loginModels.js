const { db } = require('../config/db');

const isInUsers = async(username, password) => {
    try {
        const result = await db.query(
            'SELECT * FROM users WHERE username = $1 and password = $2', 
            [username, password]
        );
        
        return result.rows;
    } catch (err) {
        console.error('Error executing query', err.stack);
        throw err;
    }
}


module.exports = {isInUsers}