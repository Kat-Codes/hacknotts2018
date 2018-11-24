var mongoose     = require('mongoose');
var Schema       = mongoose.Schema;
 
var personSchema   = new Schema({
  name: {
    type: String,
    required: "Enter name of person"
  },
  image: {
    data: Buffer,
    contentType: String
  },
});
 
module.exports = mongoose.model('People', personSchema);
