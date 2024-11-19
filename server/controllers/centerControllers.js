const centerModel = require("../models/centerModels")
const userModel = require("../models/userModels")
const axios = require('axios');
require('dotenv').config();

const GOOGLE_MAPS_API_KEY = process.env.GOOGLE_MAPS_API_KEY;

async function getCoordinatesBAddress(address) {
    try {
      const response = await axios.get(`https://maps.googleapis.com/maps/api/geocode/json`, {
        params: {
          address: address,
          key: GOOGLE_MAPS_API_KEY,
        },
      });
  
      if (response.data.status === 'OK') {
        const location = response.data.results[0].geometry.location;
        return {
          lat: location.lat,
          lng: location.lng,
        };
      } else {
        throw new Error('No results found for the specified address');
      }
    } catch (error) {
      console.error('Error fetching coordinates:', error);
      throw error;
    }
  }

const createCenter = async(req, res) =>{
    const { userId, adminId, centerNa, centerAdd,totalCapac, acceptsM, acceptsV, acceptsC } = req.body;
    try {
        await userModel.updateAdminValue(userId, true);
        
        const {lat, lng } = await getCoordinatesBAddress(centerAdd);
        const response = await centerModel.createCenter( userId, adminId, centerNa, centerAdd, currentCapac ,totalCapac, acceptsM, acceptsV, acceptsC, lat, lng);
        res.json(response);

        
    } catch (err) {
        console.error('Error in creation of users controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const getAllCoordinates = async(req, res) =>{
    try{
        const users = await centerModel.getAllCoordinates();
        res.json(users);

    }catch(err){
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const getCenterInfo = async(req, res) =>{
    const {centerId} = req.body;
    try{
        const center = await centerModel.getCenterInfo(centerId);
        res.json(center);
    }catch(err){
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

module.exports = {createCenter, getAllCoordinates, getCenterInfo}