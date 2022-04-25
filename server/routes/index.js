const express = require('express');

const router = express.Router();

router.get('/', (req, res, next) => { // rfid - (req, res, next) = request response next

    res.json({ test: 'test' }); // rfid - teste

});

module.exports = router;