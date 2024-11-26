const { supabase } = require('../config/db'); 

//New center creation
const createCenter = async (userId, adminId, centerNa, centerAdd ,totalCapac, acceptsM, acceptsV, acceptsC, lat, lng) => {
  try {
    const { data, error } = await supabase
      .from('centers')
      .insert([{ approvedBy: adminId, centerName: centerNa ,centerAddress: centerAdd, totalCapacity: totalCapac, acceptsMeat: acceptsM, acceptsVegetables: acceptsV, acceptsCans: acceptsC,latitude: lat, longitude: lng, centerAdmin: userId}])
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
      .select('id, centerName, centerAddress, latitude, longitude, currentCapacity, totalCapacity');

    if (error) {
      throw new Error(`Error executing query: ${error.message}`);
    }

    return data; // Return the array of coordinates
  } catch (err) {
    console.error('Error fetching coordinates:', err);
    throw err;
  }
};

const getAdminApprovedCenters = async(adminId) => {
  try {
      const { data, error } = await supabase
        .from('centers')
        .select('*')
        .eq('approvedBy', adminId);
  
      if (error) {
        throw new Error(`Error fetching admin approved centers: ${error.message}`);
      }
  
      return data;
    } catch (err) {
      console.error('Error fetching admin approved centers:', err);
      throw err;
    }
}

const getCenterInfo = async (centerId) => {
  try {
    const { data, error } = await supabase
      .from('centers')
      .select('*')
      .eq('id', centerId)
      .single();

    if (error) {
      throw new Error(`Error fetching center info: ${error.message}`);
    }

    return data;
  } catch (err) {
    console.error('Error fetching center info:', err);
    throw err;
  }
};

const getCoordinatesById = async (centerId) => {
  try {
    const { data, error } = await supabase
      .from('centers')
      .select('latitude, longitude')
      .eq('id', centerId)
      .single();

    if (error) {
      throw new Error(`Error fetching coordinates by ID: ${error.message}`);
    }

    return data;
  }
  catch(err){
    console.error('Error fetching coordinates by ID:', err);
    throw err;
  }
};

module.exports = { createCenter, getAllCoordinates, getAdminApprovedCenters, getCenterInfo, getCoordinatesById};