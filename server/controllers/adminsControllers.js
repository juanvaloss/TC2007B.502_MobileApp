const adminModel = require("../models/adminsModels");
const tfaModel = require("../models/tfasModels");
const {sendOTP} = require("../config/mg")

const loginAdmin = async (req, res) => {
    const { email, plainPassword } = req.body;

    try {
        const adminInfo = await adminModel.isInAdmins(email, plainPassword);
    
        if (adminInfo.isMatch === true) {
            const otpCode = await sendOTP(email);
            const assignCodeOk = await tfaModel.assignCodetoAdmin(adminInfo.user.id, otpCode);

            if(assignCodeOk === true){
                res.status(200).json({ success: true, message: 'Admin login succesful!', adminId: adminInfo.user.id});
            }
            
        } else {
            res.status(401).json({ success: false, message: 'Invalid credentials' });
        }
    } catch (err) {
        console.error('Error in loginStudent controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

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


module.exports = { loginAdmin, createAdmin, getAdminApprovedCenters, getAdminInfo };