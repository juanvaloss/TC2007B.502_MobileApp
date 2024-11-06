const { supabase } = require('../config/db');

const uploadImageOfCenter = async (file) => {
    try{
        const { data, error } = await supabase.storage
        .from('imagesOfCenter') // Replace 'my-bucket' with your bucket name
        .upload(`images/${file.name}`, file, {
            cacheControl: '3600',
            upsert: false, // Set to true to overwrite if file exists
        });
    }catch (error) {
        console.error('Error uploading file:', error.message);
    }
    
    
};

module.exports = {uploadImageOfCenter};