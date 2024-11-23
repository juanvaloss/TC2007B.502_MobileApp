const { supabase } = require('../config/db');

const registerDonation = async(receivIn, quan) =>{
    try {        
        let { data, error } = await supabase
          .from('donations')
          .insert([{ receivedIn: receivIn, quantity: quan }])
          .select('*')
          .single();
    
        if (error) {
          throw new Error(`Error executing query: ${error.message}`);
        }

        console.log('Donation registered:', data);
    
      } catch (err) {
        console.error('Error register the donation:', err);
        throw err;
      }
}

module.exports = { registerDonation }