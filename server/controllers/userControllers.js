const userModel = require("../models/userModels");
const tfaModel = require("../models/tfasModels");
const {sendOTP} = require("../config/mg")


const loginUser = async (req, res) => {
    const { email, plainPassword } = req.body;

    try {
        const userInfo = await userModel.isInUsers(email, plainPassword);
    
        if (userInfo.isMatch === true) {
            const otpCode = await sendOTP(email);
            const assignCodeOk = await tfaModel.assignCode(userInfo.user.id, otpCode);

            if(assignCodeOk === true){
                res.status(200).json({ success: true, message: 'Login succesful!', userId: userInfo.user.id});
            }
            
        } else {
            res.status(401).json({ success: false, message: 'Invalid credentials' });
        }
    } catch (err) {
        console.error('Error in loginStudent controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

const createUser = async (req, res) => {
    const { name, email, plainPassword } = req.body;
    
    try {
        const response = await userModel.createUser(name, email, plainPassword);
        res.status(201).json(response); // 201 for resource creation success
      } catch (err) {
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
      }
};
  

const getUserInfo = async(req, res) =>{
    const { userId } = req.body;
    try{
        const response = await userModel.getUserInfo(userId);
        res.json(response);

    }catch(err){
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const getUserCenters = async(req, res) =>{
    const { userId } = req.body;
    try{
        const response = await userModel.getUserCenters(userId);
        res.json(response);

    }catch(err){
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const updateAdminValue = async(req, res) =>{
    const { userId, value } = req.body;
    try{
        const response = await userModel.updateAdminValue(userId, value);
        res.json(response);

    }catch(err){
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}



module.exports = { createUser, loginUser, getUserInfo, getUserCenters, updateAdminValue};