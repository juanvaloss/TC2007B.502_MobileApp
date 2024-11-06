const imageModel = require('../models/imageModel');

const uploadImageOfCenter = async (req, res) => {
    const { centerId, imageEncoded } = req.body;
    const file = imageEncoded;
    try{
        const response = await imageModel.uploadImageOfCenter(file);
        res.status(200).json({ success: true, message: 'Image uploaded successfully.' });
    }catch(err){
        console.error('Error in image controller.', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}