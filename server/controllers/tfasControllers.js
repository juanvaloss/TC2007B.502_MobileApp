const tfaModel = require("../models/tfasModels")
const userModel = require("../models/userModels")
const adminModel = require("../models/adminsModels")
const {sendOTP} = require("../config/mg");
const e = require("express");

const verifyOTP = async ( savedOtp, userSentOtp, codeTimestamp) => {
  
    if (!codeTimestamp) {
      console.log('Invalid OTP.');
      throw false;
    }
  
    const now = Date.now();
    const date = new Date(codeTimestamp);
    console.log(now)
    const tenMinutes = 10 * 60 * 1000;
  
    if (now - date > tenMinutes) {
      console.log('OTP expired.');
      throw false;
    }

    if(savedOtp === userSentOtp){
        console.log('OTP verified successfully.');
        return true;
    }
  
    console.log('OTP doesn\'t match.');
    throw false;
}

const twoFactAuthVerification = async(req, res) => {
    const { userId, codeSentForVeri } = req.body;
    try{

        let response1 = await tfaModel.getLatestCodeUser(userId);

        if (!response1) {
            response1 = await tfaModel.getLatestCodeAdmin(userId);
            console.log(response1)
        }

        const savedOtpCode = response1.code;
        const codeTimestamp = response1.createdAt;
        const verificationStatus = await verifyOTP(savedOtpCode, codeSentForVeri, codeTimestamp);

        if(verificationStatus === true){

            const userInfo = await userModel.getUserInfo(userId);
            const adminInfo = await adminModel.getAdminInfo(userId);

            
            if(adminInfo){
                res.status(200).json({adminInfo, isBamxAdmin: true})
                await tfaModel.eraseAllAdminCodes(userId);
            }
            else{
                res.status(200).json({userInfo, isBamxAdmin: false})
                await tfaModel.eraseAllUserCodes(userId);
            }
            return true;
        }
        return false;
    }catch(err){
        console.error('Error in TFA controller.', err);
        res.status(500).json({ success: false, message: 'Server error' });
        return false;
    }
}

const getNewCode = async(req, res) =>{
    const { userId, email } = req.body;
    

    try{
        const otpCode = await sendOTP(email);
        if(otpCode === null){
            console.error('Error in assigning new code.', err);
            res.status(500).json({ success: false, message: 'Server error' });
        }

        const assignCodeOk = await tfaModel.assignCode(userId, otpCode);

        res.status(200).json({ success: true, message: 'New code was sent succesfully!', userId: userId});
        

    }catch(err){
        console.error('Error in assigning new code.', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }

}

  
module.exports = {twoFactAuthVerification, getNewCode}