const applicationModel = require("../models/applicationsModels")
const userModel = require("../models/userModels")

const getApplicationInfo = async(req, res) => {
    const {userId} = req.body;
    try {
        const response = await applicationModel.getApplicationInfo(userId);
        res.json(response);
    } catch (err) {
        console.error('Error fetching the application', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const createApplication = async(req, res) => {
    const {userId, centerName, centerAddress, capac, acceptsM, acceptsV, acceptsC} = req.body;

    try {   
        const userInfo = await userModel.getUserInfo(userId);
        if(userInfo.isCenterAdmin === false){
            const response = await applicationModel.createApplication( userId, centerName, centerAddress, capac, acceptsM, acceptsV, acceptsC );
            res.json(response);
        }else{
            res.json({message: "El usuario ya es administrador de un centro de acopio."});
        }
        
    } catch (err) {
        console.error('Error creating an application.', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const deleteApplication = async(req, res) =>{
    const { applicationId } = req.body;
    try {
        const response = await applicationModel.deleteApplication( applicationId );
        res.json(response);
       
    } catch (err) {
        console.error('Error deleting an application.', err);
        res.status(500).json({ success: false, message: 'Server error' });
    } 
}

const getAllApplications = async(req, res) => {
    try {
        const response = await applicationModel.getAllApplications();
        res.json(response);
    } catch (err) {
        console.error('Error fetching all the applications.', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

module.exports = { getApplicationInfo ,createApplication, deleteApplication, getAllApplications}