const centerModel = require("../models/centerModels")
const userModel = require("../models/userModels")

const createCenter = async(req, res) =>{
    const { userId, adminId, centerNa, centerAdd, currentCapac ,totalCapac, acceptsM, acceptsV, acceptsC, lat, lon } = req.body;
    try {
        const modifyUser = await userModel.updateAdminValue(userId, True);
        
        const response = await centerModel.createCenter( userId, adminId, centerNa, centerAdd, currentCapac ,totalCapac, acceptsM, acceptsV, acceptsC, lat, lon );
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