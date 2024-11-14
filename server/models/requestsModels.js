const { supabase } = require('../config/db'); 


const getRequestInfo = async (userId) => {
  try {
    const { data, error } = await supabase
      .from('requests')
      .select('*')
      .eq('solicitor', userId);

    if (error) {
      throw new Error(`Error fetching request: ${error.message}`);
    }

    return data;
  } catch (err) {
    console.error('Error fetching request:', err);
    throw err;
  }

}


const createRequest = async (userId, centerNa, centerAdd, capac, acceptsM, acceptsV, acceptsC) => {
  try {
    const { data, error } = await supabase
      .from('requests')
      .insert([{ solicitor: userId, centerName: centerNa, centerAddress: centerAdd, capacity: capac, acceptsMeat: acceptsM, acceptsVegetables: acceptsV, acceptsCans: acceptsC }])
      .select('*')
    if (error) {
      throw new Error(`Error executing query: ${error.message}`);
    }

    return data[0]; // Return the created center data
  } catch (err) {
    console.error('Error creating request:', err);
    throw err;
  }
};

const deleteRequest = async(requestId) =>{
  try{
    const { data, error } = await supabase
    .from('requests')
    .delete()
    .eq('id', requestId);

    if(error){
      throw new Error(`Error executing query: ${error.message}`);
    }

    return data

  }catch(err){
    console.error('Error deleting request:', err);
    throw err;
  }
}

module.exports = { getRequestInfo ,createRequest, deleteRequest };