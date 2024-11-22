const donationModel = require("../models/donationsModels")
const centerModel = require("../models/centerModels")

const registerDonation = async( req, res ) =>{
    const { receivIn, ty, quan } = req.body;

    try{
        const centerInfo = await centerModel.getCenterInfo(receivIn);
        if(centerInfo.currentCapacity + quan > centerInfo.totalCapacity){
            return res.status(400).json({ success: false, message: 'Capacity exceeded' });
        }
        
        const response = await donationModel.registerDonation(receivIn, ty, quan);
        res.json(response);

    }catch(err){
        console.error('Error in donation controller.', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
} 

module.exports = { registerDonation }