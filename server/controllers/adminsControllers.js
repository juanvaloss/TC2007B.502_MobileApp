const adminModel = require("../models/adminsModels");
const tfaModel = require("../models/tfasModels");
const {sendOTP} = require("../config/mg")


const createAdmin = async (req, res) => {
    const { name, email, plainPassword } = req.body;
    
    try {
        const response = await adminModel.createAdmin(name, email, plainPassword);
        res.status(201).json(response);
      } catch (err) {
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
      }
};
  
const getAdminApprovedCenters = async(req, res) =>{
    const { adminId } = req.body;
    try{
        const response = await adminModel.getAdminApprovedCenters(adminId);
        res.json(response);

    }catch(err){
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const getAdminInfo = async(req, res) =>{
    const { userId } = req.body;
    try{
        const response = await adminModel.getAdminInfo(userId);
        res.json(response);

    }catch(err){
        console.error('Error obtaining admin info', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}


module.exports = {createAdmin, getAdminApprovedCenters, getAdminInfo };