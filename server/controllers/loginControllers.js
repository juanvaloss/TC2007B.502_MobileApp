const loginModel = require("../models/loginModels");


const loginUser = async (req, res) => {
    const { username, password } = req.body;

    try {
        const users = await loginModel.isInUsers(username, password);

        if (users.length > 0) {
            res.status(200).json({ success: true, message: 'Login successful' });
        } else {
            res.status(401).json({ success: false, message: 'Invalid credentials' });
        }
    } catch (err) {
        console.error('Error in loginStudent controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
};

module.exports = {loginUser}