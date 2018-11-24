var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');
var routes     = require('./routes/routes');
 	
var Person     = require('./models/personModel');
var port = process.env.PORT || 3000;

var mongoose = require("mongoose");
mongoose.connect('mongodb://localhost/restdb')

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/', routes);
 
app.listen(port);
console.log('listening on port: ' + port);