require('dotenv').config();

const getCoordinatesBAddress = async (address) => {
  const fetch = (await import('node-fetch')).default;
  const apiKey = process.env.GOOGLE_MAPS_API_KEY
  const url = `https://maps.googleapis.com/maps/api/geocode/json?address=${encodeURIComponent(address)}&key=${apiKey}`;

  try {
    const response = await fetch(url);
    const data = await response.json();

    if (data.status === 'OK') {
      const { lat, lng } = data.results[0].geometry.location;
      console.log(`Latitude: ${lat}, Longitude: ${lng}`);
      return { lat, lng };
    } else {
      console.error('Error fetching coordinates:', data.status);
      return null;
    }
  } catch (error) {
    console.error('Error:', error);
  }
};

// Example usage:
module.exports =  getCoordinatesBAddress