const requestModel = require("../models/requestsModels")
const userModel = require("../models/userModels")

const createRequest = async(req, res) => {
    const {userId, centerName, centerAddress, capac, acceptsM, acceptsV, acceptsC} = req.body;

    console.log(userId, centerName, centerAddress, capac, acceptsM, acceptsV, acceptsC);
    try {
        
        const userInfo = await userModel.getUserInfo(userId);
        if(userInfo.isCenterAdmin === false){
            const response = await requestModel.createRequest( userId, centerName, centerAddress, capac, acceptsM, acceptsV, acceptsC );
            res.json(response);
        }else{
            res.json({message: "El usuario ya es administrador de un centro de acopio."});
        }
        
    } catch (err) {
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}


module.exports = {createRequest}