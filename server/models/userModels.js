const { db } = require('../config/db');
const bcrypt = require('bcrypt');

//Function to hash the password, might be changed ...
const hashPassword = async (plainPassword) => {
    try {
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(plainPassword, salt);
      return hashedPassword;

    } catch (error) {
      console.error('Error hashing password:', error);
      throw error;
    }
};

//Login with encrypted password
const isInUsers = async(username, plainPassword) => {
    try {
        const result = await db.query(
            'SELECT * FROM users WHERE username = $1',
            [username]
        );
      
        if (result.rows.length === 0) {
            console.log('User not found');
            return false;
        }
      
        const user = result.rows[0];
        const storedHashedPassword = user.password;
      
        const isMatch = await bcrypt.compare(plainPassword, storedHashedPassword);
        return isMatch;
      
    } catch (err) {
        console.error('Error executing query', err.stack);
        throw err;
    }
}

//Basic register, more info abt the user needs to be added.
const createUser = async(name, email, plainPassword) =>{
    try{
        const hashedPassword = await hashPassword(plainPassword);
        const query = 'INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING *;';
        const response = await db.query(query, [name, email, hashedPassword]);
        return response.rows[0];
        
    }catch(err){
        console.error(err)
        console.error('Error executing query', err.stack);
        throw err;
    }
}

//For personal profile
const getUserInfo = async(userId) =>{
    try{
        const query = 'SELECT name, email FROM users WHERE id = $1;';
        const userInfo = await db.query(query, [userId]);
        return userInfo.rows[0];

    }catch(err){
        console.error(err)
        console.error('Error executing query', err.stack);
        throw err;
    }
}

//Might get changed to a single query ...
const getUserCenters = async(userId) =>{
    try{
        const query = 'SELECT name, address,latitude,longitude  FROM centers WHERE administrator = $1;';
        const userInfo = await db.query(query, [userId]);
        return userInfo.rows[0];

    }catch(err){
        console.error(err)
        console.error('Error executing query', err.stack);
        throw err;
    }
}


module.exports = {isInUsers, createUser, getUserInfo, getUserCenters}