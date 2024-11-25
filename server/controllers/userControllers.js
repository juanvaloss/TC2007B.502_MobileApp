const userModel = require("../models/userModels");
const adminModel = require("../models/adminsModels");
const tfaModel = require("../models/tfasModels");
const {sendOTP} = require("../config/mg");

const createUser = async (req, res) => {
    const { name, email, plainPassword } = req.body;
    
    try {
        const userInfo = await userModel.alreadyExists(email);
        const adminInfo = await adminModel.alreadyExists(email);
        console.log(userInfo);
    
        if (userInfo === true || adminInfo === true) {
            res.status(403).json({ success: false, message: 'Email used by another account, login!' });
            return;
        }



        const response = await userModel.createUser(name, email, plainPassword);
        const otpCode = await sendOTP(email);
        const assignCodeOk = await tfaModel.assignCodetoUser(response.id, otpCode);

        if(assignCodeOk === true){
            res.status(200).json({ type: 1, userId: response.id});
        }else{
            throw false;
        }
            

        
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
        console.error('Error in getting user info', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const getUserCenters = async(req, res) =>{
    const { userId } = req.body;
    try{
        const response = await userModel.getUserCenters(userId);
        if (response === null){
            res.status(404).json({message: 'No centers found' });
            return;
        }
        res.json(response);

    }catch(err){
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const getUserApplication = async(req, res) =>{
    const { userId } = req.body;
    try{
        const response = await userModel.getUserApplication(userId);
        if (response === null){
            res.status(404).json({id: 0});
            return;
        }
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

const deleteUser = async(req, res) =>{
    const { userId } = req.body;
    try{
        const response = await userModel.deleteUser(userId);
        res.json(response);

    }catch(err){
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}



module.exports = { createUser, getUserInfo, getUserCenters, updateAdminValue, deleteUser, getUserApplication};