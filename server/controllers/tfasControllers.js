const tfaModel = require("../models/tfasModels")
const userModel = require("../models/userModels")
const adminModel = require("../models/adminsModels")
const {sendOTP} = require("../config/mg");

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

const twoFactAuthVerificationAdmin = async(req, res) => {
    const { userId, codeSentForVeri } = req.body;
    try{

        let response1 = await tfaModel.getLatestCodeAdmin(userId);

        const savedOtpCode = response1.code;
        const codeTimestamp = response1.createdAt;
        const verificationStatus = await verifyOTP(savedOtpCode, codeSentForVeri, codeTimestamp);

        if(verificationStatus === true){

            var userInfo = await adminModel.getAdminInfo(userId);

            res.status(200).json({userId: userInfo.id , isBamxAdmin: true})
            await tfaModel.eraseAllAdminCodes(userId);
            

            return true;
        }else{
            res.status(400).json({ success: false, message: 'Invalid code' });
            return false;

        }
        
    }catch(err){
        console.error('Error in TFA controller.', err);
        res.status(500).json({ success: false, message: 'Server error' });
        return false;
    }
}

const twoFactAuthVerificationUser = async(req, res) => {
    const { userId, codeSentForVeri } = req.body;
    try{

        let response1 = await tfaModel.getLatestCodeUser(userId);

        const savedOtpCode = response1.code;
        const codeTimestamp = response1.createdAt;
        const verificationStatus = await verifyOTP(savedOtpCode, codeSentForVeri, codeTimestamp);

        if(verificationStatus === true){

            var userInfo = await userModel.getUserInfo(userId);

            res.status(200).json({userId: userInfo.id, isBamxAdmin: false})
            await tfaModel.eraseAllUserCodes(userId);
            

            return true;
        }else{
            res.status(400).json({ success: false, message: 'Invalid code' });
            return false;

        }
        
    }catch(err){
        console.error('Error in TFA controller.', err);
        res.status(500).json({ success: false, message: 'Server error' });
        return false;
    }

}

const getNewCodeUser = async(req, res) =>{
    const { userId, email } = req.body;

    try{
        const otpCode = await sendOTP(email);
        if(otpCode === null){
            console.error('Error in assigning new code.', err);
            res.status(500).json({ success: false, message: 'Server error' });
        }

        await tfaModel.assignCodetoUser(userId, otpCode);

        res.status(200).json({ success: true, message: 'New code was sent succesfully!', userId: userId});
        

    }catch(err){
        console.error('Error in assigning new code.', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }

}

const getNewCodeAdmin = async(req, res) =>{
    const { userId, email } = req.body;

    try{
        const otpCode = await sendOTP(email);
        if(otpCode === null){
            console.error('Error in assigning new code.', err);
            res.status(500).json({ success: false, message: 'Server error' });
        }

        await tfaModel.assignCodetoAdmin(userId, otpCode);

        res.status(200).json({ success: true, message: 'New code was sent succesfully!', userId: userId});
        

    }catch(err){
        console.error('Error in assigning new code.', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }

}
  
module.exports = {twoFactAuthVerificationAdmin, twoFactAuthVerificationUser, getNewCodeUser, getNewCodeAdmin};