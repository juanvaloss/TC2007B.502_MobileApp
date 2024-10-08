const centerModel = require("../models/centerModels")

const createCenter = async(req, res) =>{
    const { adminId, centerName, centerAddress, lat, lon } = req.body;
    try {
        const response = await centerModel.createCenter( adminId, centerName, centerAddress, lat, lon );
        res.json(response);

        
    } catch (err) {
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const getAllCoordinates = async(req, res) =>{
    try{
        const users = await centerModel.getAllCoordinates();
        res.json(users);

    }catch(err){
        res.status(500).json({ success: false, message: 'Server error' });
    }
}


module.exports = {createCenter, getAllCoordinates}