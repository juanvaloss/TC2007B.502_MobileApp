const requestModel = require("../models/requestsModels")
const userModel = require("../models/userModels")

const getRequestInfo = async(req, res) => {
    const {userId} = req.body;
    try {
        const response = await requestModel.getRequestInfo(userId);
        res.json(response);
    } catch (err) {
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const createRequest = async(req, res) => {
    const {userId, centerName, centerAddress, capac, acceptsM, acceptsV, acceptsC} = req.body;

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

const deleteRequest = async(req, res) =>{
    const { requestId } = req.body;
    try {
        const response = await requestModel.deleteRequest( requestId );
        res.json(response);
       
    } catch (err) {
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    } 
}

module.exports = { getRequestInfo ,createRequest, deleteRequest}