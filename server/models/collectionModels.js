const { supabase } = require('../config/db');


const hasCenterSolicited = async (centerId) => {
    try {
      const { data, error } = await supabase
        .from('collectionRequests')
        .select('*')
        .eq('centerRequesting', centerId)
        .single();

        if(data == null){
            return null;
        }

        if (error) {
            throw new Error(`Error fetching collections: ${error.message}`);
        }

        return data;
    
      
      } catch (err) {
        console.error('Error fetching collections:', err);
        throw err;
    }
}

const getAllCollections = async () => {
    try {
        const { data, error } = await supabase
            .from('collectionRequests')
            .select('*');

        if (error) {
            throw new Error(`Error fetching collections: ${error.message}`);
        }

        return data;
    } catch (err) {
        console.error('Error fetching collections:', err);
        throw err;
    }

}

const registerCollection = async (centerId, centerName,status) => {
    try {
        let { error } = await supabase
            .from('collectionRequests')
            .insert([{ centerRequesting: centerId, centerName: centerName, centerStatus: status }]);

        if (error) {
            throw new Error(`Error executing query: ${error.message}`);
        }

    } catch (err) {
        console.error('Error register the collection:', err);
        throw err;
    }

}

const deleteCollection = async(collectionId) =>{
    try{
      const { data, error } = await supabase
      .from('collectionRequests')
      .delete()
      .eq('id', collectionId);
  
      if(error){
        throw new Error(`Error executing query: ${error.message}`);
      }
  
    }catch(err){
      console.error('Error deleting collection:', err);
      throw err;
    }
  }

module.exports = { getAllCollections, registerCollection, hasCenterSolicited, deleteCollection }