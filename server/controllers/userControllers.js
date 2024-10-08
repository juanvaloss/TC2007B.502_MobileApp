const userModel = require("../models/userModels");

const loginUser = async (req, res) => {
    const { username, plainPassword } = req.body;

    try {
        const users = await userModel.isInUsers(username, plainPassword);

        if (users === true) {
            res.status(200).json({ success: true, message: 'Login successful' });
        } else {
            res.status(401).json({ success: false, message: 'Invalid credentials' });
        }
    } catch (err) {
        console.error('Error in loginStudent controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

const createUser = async(req, res) =>{
    const { name, email, plainPassword } = req.body;
    try {
        const response = await userModel.createUser(name, email, plainPassword);
        res.json(response);

        
    } catch (err) {
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}



module.exports = {loginUser, createUser}