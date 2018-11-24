var express = require('express');
var router = express.Router();
var Message     = require('./models/personModel');
 
router.get('/', function(req, res) {
    res.json({ message: 'Welcome' });   
});
 
router.route('/people')
    .get(function(req, res) {
        People.find(function(err, people) {
            if (err)
                res.send(err);
            res.json(people);
        });
    });
 
module.exports = router;
 