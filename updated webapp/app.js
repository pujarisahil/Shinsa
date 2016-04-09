var express = require("express");
var app = express();

app.set("view engine", "ejs");

app.get("/", function(req, res) {
    res.render("landing");
});

app.get("/register", function(req, res) {
  res.render("register");
});

app.post("/register", function(req, res){
    res.send("Congratulations, you played yourself");
});

app.post("/login", function(req, res){
    res.send("Congratulations, you played yourself");
});

app.get("/auth/facebook", function(req, res){
  res.render("profile");
});

app.get("/login", function(req, res) {
  res.render("login");
});

app.get("/profile", function(req, res) {
  res.render("profile");
});

app.get("/edit-profile", function(req, res) {
  res.render("editProfile");
});

app.get("/leaderboard", function(req, res) {
  res.render("leaderboard");
});


app.listen(process.env.PORT, process.env.IP, function() {
    console.log("It has started bro");
});