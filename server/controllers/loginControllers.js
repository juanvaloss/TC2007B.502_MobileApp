const userModel = require("../models/userModels");
const tfaModel = require("../models/tfasModels");
const adminModel = require("../models/adminsModels");
const {sendOTP} = require("../config/mg")

const globalLogin = async (req, res) => {
    const { email, plainPassword } =  req.body;

    try{
        const userInfo = await userModel.isInUsers(email, plainPassword);
        const adminInfo = await adminModel.isInAdmins(email, plainPassword);

        if (userInfo.isMatch === true) {
            const otpCode = await sendOTP(email);
            const assignCodeOk = await tfaModel.assignCodetoUser(userInfo.user.id, otpCode);

            if(assignCodeOk === true){
                res.status(200).json({ type: 1, userId: userInfo.user.id});
                return true;
            }
            
        } else if(adminInfo.isMatch === true){
            const otpCode = await sendOTP(email);
            const assignCodeOk = await tfaModel.assignCodetoAdmin(adminInfo.user.id, otpCode);

            if(assignCodeOk === true){
                res.status(200).json({ type: 2, userId: adminInfo.user.id});
                return true;
            }
        } else {
            res.status(401).json({ success: false, message: 'Invalid credentials' });
            return false;
        }

    } catch (err) {
        console.error('Error in global login controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

module.exports = {globalLogin}
