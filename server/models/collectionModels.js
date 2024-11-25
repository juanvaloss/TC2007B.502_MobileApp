const { supabase } = require('../config/db');


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
        let { data, error } = await supabase
            .from('collectionRequests')
            .insert([{ centerId: centerId, centerName: centerName, status: status }]);

        if (error) {
            throw new Error(`Error executing query: ${error.message}`);
        }

        console.log('Collection registered:', data);

    } catch (err) {
        console.error('Error register the collection:', err);
        throw err;
    }

}

module.exports = { getAllCollections, registerCollection }