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
const isInAdmins = async (email, plainPassword) => {
    try {
      const { data, error } = await supabase
        .from('admins')
        .select('id, password')
        .eq('email', email);
  
      if (error) {
        throw new Error(`Error executing query: ${error.message}`);
      }
  
      if (data.length === 0) {
        console.log('Admin not found');
        return false;
      }
  
      const user = data[0];
      const storedHashedPassword = user.password;
  
      const isMatch = await bcrypt.compare(plainPassword, storedHashedPassword);
      return { isMatch, user };
    } catch (err) {
      console.error('Error fetching user:', err);
      throw err;
    }
};

//Won't be available to the end user
const createAdmin = async (name, email, plainPassword) => {
    try {
        const hashedPassword = await hashPassword(plainPassword);
        
        // Insert into the Supabase database
        let { data, error } = await supabase
          .from('admins')
          .insert([{ name, email, password: hashedPassword }])
          .select();
    
        if (error) {
          throw new Error(`Error executing query: ${error.message}`);
        }
    
        return data[0];
      } catch (err) {
        console.error('Error creating user:', err);
        throw err;
      }
};

//
const getAdminInfo = async (userId) => {
  try {
    const { data, error } = await supabase
      .from('admins')
      .select('id, name, email')
      .eq('id', userId)
  
      if (data.length > 0) {
        console.log('Admin found');
        const user = data[0];
        return user;
      }

      else{
          const user = 0;
          isMatch = false;
          console.log('Admin not found in table admins');
          return user;
      }
  
      return data;
  } catch (err) {
    console.error('Error fetching admin info:', err);
    throw err;
  }
};


module.exports = {isInAdmins, createAdmin, getAdminInfo};