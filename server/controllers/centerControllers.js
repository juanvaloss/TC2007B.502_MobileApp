const centerModel = require("../models/centerModels")
const userModel = require("../models/userModels")

const createCenter = async(req, res) =>{
    const { userId, adminId, centerNa, centerAdd, currentCapac ,totalCapac, acceptsM, acceptsV, acceptsC } = req.body;
    try {
        const modifyUser = await userModel.updateAdminValue(userId, true);
        const {lat, lng } = await getCoordinatesBAddress(centerAdd);
        const response = await centerModel.createCenter( userId, adminId, centerNa, centerAdd, currentCapac ,totalCapac, acceptsM, acceptsV, acceptsC, lat, lng);
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