var express = require("express");
var router = express.Router();
var Message = require("./models/personModel");

router.get("/", function(req, res) {
  res.json({ message: "Welcome" });
});

// Get all people
router.route("/people").get(function(req, res) {
  People.find(function(err, people) {
    if (err) res.send(err);
    res.json(people);
  });
});

// post a person
router.route("/people").post(function(req, res) {
  var people = new People();
  message.name = req.body.name;
  message.image = req.body.img;

  // Save message and check for errors
  person.save(function(err) {
    if (err) res.send(err);
    res.json({ person: "Person created successfully!" });
  });
});

module.exports = router;
