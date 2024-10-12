const { supabase } = require('../config/db');

//This could be changed ... 
const registerDonation = async(receivIn, ty, quan) =>{
    try {        
        // Insert into the Supabase database
        let { data, error } = await supabase
          .from('donations')
          .insert([{ receivedIn: receivIn, type: ty, quantity: quan }])
          .select();
    
        if (error) {
          throw new Error(`Error executing query: ${error.message}`);
        }
    
        return data[0];
      } catch (err) {
        console.error('Error register the donation:', err);
        throw err;
      }
}

module.exports = { registerDonation }