const collectionModel = require('../models/collectionModels');

const getAllCollections = async (req, res) => {
    try {
        const response = await collectionModel.getAllCollections();
        res.json(response);

    } catch (err) {
        console.error('Error in creation of collection controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const registerCollection = async (req, res) => {
    const { centerId, centerName, status } = req.body;

    if(await collectionModel.hasCenterSolicited(centerId) != null){
        console.log('Center already solicited');
        res.status(400).json({ message: 'Center already solicited' });
        return;
    }

    try {
        console.log('Center hasn\'t solicited');
        await collectionModel.registerCollection(centerId, centerName, status);
        res.status(200).json({ message: 'Collection registered' });

    } catch (err) {
        console.error('Error in creation of collection controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

const deleteCollection = async (req, res) => {
    const { collectionId } = req.body;

    try {
        await collectionModel.deleteCollection(collectionId);
        res.status(200).json({ message: 'Collection deleted' });

    } catch (err) {
        console.error('Error in creation of collection controller', err);
        res.status(500).json({ success: false, message: 'Server error' });
    }
}

module.exports = { registerCollection, getAllCollections, deleteCollection }