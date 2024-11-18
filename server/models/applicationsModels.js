const { supabase } = require('../config/db'); 


const getApplicationInfo = async (userId) => {
  try {
    const { data, error } = await supabase
      .from('applications')
      .select('*')
      .eq('solicitor', userId);

    if (error) {
      throw new Error(`Error fetching application: ${error.message}`);
    }

    return data;
  } catch (err) {
    console.error('Error fetching application:', err);
    throw err;
  }

}


const createApplication = async (userId, centerNa, centerAdd, capac, acceptsM, acceptsV, acceptsC) => {
  try {
    const { data, error } = await supabase
      .from('applications')
      .insert([{ solicitor: userId, centerName: centerNa, centerAddress: centerAdd, capacity: capac, acceptsMeat: acceptsM, acceptsVegetables: acceptsV, acceptsCans: acceptsC }])
      .select('solicitor, centerName')
      
    if (error) {
      throw new Error(`Error executing query: ${error.message}`);
    }

    return data[0]; // Return the created center data
  } catch (err) {
    console.error('Error creating application:', err);
    throw err;
  }
};

const deleteApplication = async(ApplicationId) =>{
  try{
    const { data, error } = await supabase
    .from('applications')
    .delete()
    .eq('id', ApplicationId);

    if(error){
      throw new Error(`Error executing query: ${error.message}`);
    }

    return data

  }catch(err){
    console.error('Error deleting application:', err);
    throw err;
  }
}

const getAllApplications = async () => {
  try {
    const { data, error } = await supabase
      .from('applications')
      .select('*');

    if (error) {
      throw new Error(`Error fetching applications: ${error.message}`);
    }

    return data;
  } catch (err) {
    console.error('Error fetching applications:', err);
    throw err;
  }
}

module.exports = { getApplicationInfo ,createApplication, deleteApplication, getAllApplications };