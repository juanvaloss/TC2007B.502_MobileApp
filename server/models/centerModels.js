const { supabase } = require('../config/db'); 

//New center creation
const createCenter = async (userId, adminId, centerNa, centerAdd, currentCapac ,totalCapac, acceptsM, acceptsV, acceptsC, lat, lon) => {
  try {
    const { data, error } = await supabase
      .from('centers')
      .insert([{ approvedBy: adminId, centerName: centerNa ,centerAddress: centerAdd, currentCapacity: currentCapac, totalCapacity: totalCapac, acceptsMeat: acceptsM, acceptsVegetables: acceptsV, acceptsCans: acceptsC,latitude: lat, longitude: lon, centerAdmin: userId}])
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

//For mapping all the centers
const getAllCoordinates = async () => {
  try {
    const { data, error } = await supabase
      .from('centers')
      .select('id, latitude, longitude');

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