const { db } = require('../config/db');

const createCenter = async(adminId, centerName, centerAddress, lat, lon) => {
    try{
        const query = 'INSERT INTO centers (administrator, name, address, latitude, longitude) VALUES ($1, $2, $3, $4, $5) RETURNING *;';
        const response = await db.query(query, [adminId, centerName, centerAddress, lat, lon]);
        return response.rows[0];
        
    }catch(err){
        console.error(err)
        console.error('Error executing query', err.stack);
        throw err;
    }
}

const getAllCoordinates = async() =>{
    try{
        const query = 'SELECT latitude, longitude FROM centers;';
        const { rows } = await db.query(query);
        return rows;
        
    }catch(err){
        console.error(err)
        console.error('Error executing query', err.stack);
        throw err;
    }
}


module.exports = {createCenter, getAllCoordinates}