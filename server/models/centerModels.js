const supabase = require('../config/db'); 

const createCenter = async (adminId, centerName, centerAddress, lat, lon) => {
  try {
    const { data, error } = await supabase
      .from('centers')
      .insert([{ administrator: adminId, name: centerName, address: centerAddress, latitude: lat, longitude: lon }])
      .select();

    if (error) {
      throw new Error(`Error executing query: ${error.message}`);
    }

    return data[0]; // Return the created center data
  } catch (err) {
    console.error('Error creating center:', err);
    throw err;
  }
};

const getAllCoordinates = async () => {
  try {
    const { data, error } = await supabase
      .from('centers')
      .select('latitude, longitude');

    if (error) {
      throw new Error(`Error executing query: ${error.message}`);
    }

    return data; // Return the array of coordinates
  } catch (err) {
    console.error('Error fetching coordinates:', err);
    throw err;
  }
};

module.exports = { createCenter, getAllCoordinates };