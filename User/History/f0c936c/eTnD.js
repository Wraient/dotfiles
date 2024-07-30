const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
  res.render('index', { title: 'My Portfolio and Blog' });
});

module.exports = router;
