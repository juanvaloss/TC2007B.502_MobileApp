const donationModel = require("../models/donationsModels")

const registerDonation = async( req, res ) =>{
    const { receivIn, ty, quan } = req.body;
    try{
        const response = await donationModel.registerDonation(receivIn, ty, quan);
        res.json(response);

    }catch(err){
        console.error('Error in donation controller.', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
} 

module.exports = { registerDonation }