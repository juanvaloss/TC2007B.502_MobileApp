const { supabase } = require('../config/db');
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
const isInUsers = async (email, plainPassword) => {
    try {
      const { data, error } = await supabase
        .from('users')
        .select('id, password')
        .eq('email', email);
  
      if (error) {
        throw new Error(`Error executing query: ${error.message}`);
      }
  
      if (data.length > 0) {
        console.log('User found');
        const user = data[0];
        const storedHashedPassword = user.password; 
        const isMatch = await bcrypt.compare(plainPassword, storedHashedPassword);
        return {isMatch, user}
      }

      else{
        const user = 0;
        isMatch = false;
        console.log('User not found');
        return {isMatch, user}
      }
  
      
    } catch (err) {
      console.error('Error fetching user:', err);
      throw err;
    }
};


const alreadyExists = async (email) => {
  try {
    const { data, error } = await supabase
      .from('users')
      .select('id')
      .eq('email', email);

    if (error) {
      throw new Error(`Error executing query: ${error.message}`);
    }

    if (data.length > 0) {
      console.log('User found');
      return true;
    }

    else{
      console.log('User not found');
      return false;
    }

    
  } catch (err) {
    console.error('Error fetching user:', err);
    throw err;
  }

};


//Basic register, more info abt the user needs to be added.
const createUser = async (name, email, plainPassword) => {
    try {
        const hashedPassword = await hashPassword(plainPassword);
        
        // Insert into the Supabase database
        let { data, error } = await supabase
          .from('users')
          .insert([{ name, email, password: hashedPassword }])
          .select('*');
    
        if (error) {
          throw new Error(`Error executing query: ${error.message}`);
        }
    
        return data[0]; // Return the created user data
      } catch (err) {
        console.error('Error creating user:', err);
        throw err;
      }
};

//For personal profile
const getUserInfo = async (userId) => {
    try {
      const { data, error } = await supabase
        .from('users')
        .select('id, name, email, isCenterAdmin')
        .eq('id', userId);
  
      if (data.length > 0) {
          console.log('User found');
          const user = data[0];
          return user;
      }
  
      else{
          const user = 0;
          isMatch = false;
          console.log('User not found in table users');
          return user;
      }
  
      return data;
    } catch (err) {
      console.error('Error fetching user info:', err);
      throw err;
    }
};

//Might get changed to a single query ...
const getUserCenters = async (userId) => {
    try {
      const { data, error } = await supabase
        .from('centers')
        .select('id, centerName, centerAddress, latitude, longitude')
        .eq('centerAdmin', userId);
  
      if (error) {
        throw new Error(`Error fetching user centers: ${error.message}`);
      }
  
      return data;
    } catch (err) {
      console.error('Error fetching user centers:', err);
      throw err;
    }
};

const updateAdminValue = async(userId, value) => {
  try{
    const {data, error} = await supabase
    .from('users')
    .update({'isCenterAdmin': value})
    .eq('id', userId);

    if (error) {
      throw new Error(`Error updating value user centers: ${error.message}`);
    }

    return data;

  }catch(err){
    console.error('Error fetching user centers:', err)
    throw err;
  }
}

const deleteUser = async (userId) => {
  try {
    const { data, error } = await supabase
      .from('users')
      .delete()
      .eq('id', userId);

    if (error) {
      throw new Error(`Error deleting user: ${error.message}`);
    }

    return data;
  } catch (err) {
    console.error('Error deleting user:', err);
    throw err;
  }
};

  

module.exports = { createUser, isInUsers, getUserInfo, getUserCenters, updateAdminValue, deleteUser, alreadyExists };