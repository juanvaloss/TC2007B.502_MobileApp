const tfaModel = require("../models/tfasModels")
const userModel = require("../models/userModels")
const {sendOTP} = require("../config/mg")

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
        const response1 = await tfaModel.getLatestCode(userId);
        const savedOtpCode = response1.code;
        const codeTimestamp = response1.createdAt;
        const verificationStatus = await verifyOTP(savedOtpCode, codeSentForVeri, codeTimestamp);

        if(verificationStatus === true){
            const userInfo = await userModel.getUserInfo(userId);
            res.status(200).json(userInfo)
            await tfaModel.eraseAllUserCodes(userId);
            
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