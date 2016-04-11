var express = require("express");
var app = express();
var mongoose = require("mongoose");
var bodyParser = require("body-parser");
mongoose.connect("mongodb://localhost/users");


//MEMORIZE IT
app.use(bodyParser.urlencoded({extended : true}));

var userSchema = new mongoose.Schema({
  firstName: String,
  lastName: String,
  password: String,
  birthDate: String,
  fbID: String,
  generalID: String,
  gender: String,
  email: String,
  rating: Number
});

var friendSchema = new mongoose.Schema({
  email1: String,
  email2: String
});

var User = mongoose.model("User", userSchema);
var Friend = mongoose.model("Friend", friendSchema);

app.set("view engine", "ejs");

app.get("/", function(req, res) {
    res.render("landing");
});

app.get("/register", function(req, res) {
  res.render("register");
});

app.post("/register", function(req, res) {
  var firstName = req.body.firstname;
  var lastName = req.body.lastname;
  var email = req.body.email;
  var month = req.body.month;
  var day = req.body.day;
  var year = req.body.year;
  var gender = req.body.gender;
  var pass1 = req.body.password;
  var pass2 = req.body.confirm_password;
  
  if(firstName && lastName && email && month && day && year && gender && pass1 === pass2) {
    var resultArray;
    User.find({email : email}, function (err, docs) {
        if(err) {
            console.log(err);
        }
        if (docs.length){
            //console.log('Name exists already');
            //res.render("alreadyExists");
            res.send("An account already exists with this email ID");
            check = true;
        } else {
          resultArray = [firstName, lastName, day, gender, email, 0, month, year, gender];
          User.create(
          {
            firstName: firstName,
            lastName: lastName,
            gender : gender,
            email : email,
            birthDate : month + "/" + day + "/" + year,
            password : pass1,
            rating : 0
          }, function(err, user) {
            if(err) {
              console.log(err);
            } else {
              console.log("Created a new user");
              console.log(user);
              //console.log(resultArray);
              res.render("profile", {resultArray : resultArray});
            }
          });
        }
    });
  } else {
    res.send("You missed something");
  }
});


app.get("/auth/facebook", function(req, res){
  res.render("profile");
});


app.get("/fblogin", function(req, res) {
  
  var temp = req.url.split("?");
  var temp2 = temp[1];
  var temp3 = temp2.split("&");
  var firstName = (temp3[0].split("="))[1];
  var lastName = (temp3[1].split("="))[1];
  var fbID = (temp3[2].split("="))[1];
  var gender = (temp3[3].split("="))[1];
  var email = (temp3[4].split("="))[1];
  email = email.replace("%40", "@");
  
  User.find({fbID : fbID}, function (err, docs) {
        if(err) {
            console.log(err);
        }
        if (docs.length){
            var resultArray = [firstName, lastName, fbID, gender, email];
            res.render("profile", {resultArray : resultArray});
        } else {
          res.send("An account with this Facebook ID does not exist. Please register");
          //res.render("doesntExist");
        }
    });
});

app.get("/login", function(req, res) {
  res.render("login");
});

app.get("/memberProfile", function(req, res) {
  var temp = req.url.split("?");
  
  User.find({}).exec(function (err, docs) {
        if(err) {
            console.log(err);
        }
        if (docs.length){
            var myObj = JSON.parse(JSON.stringify(docs));
            var counter = 0;
            var returnArray = [];
            myObj.forEach(function(entry) {
              returnArray[counter] = entry;
              counter += 1;
            });
            
            res.render("memberProfiles", {returnArray : returnArray});
            //User.find({email : email}).lean().exec(function (err, users) {
            //res.render("alreadyExists");
        } else {
          res.send("Account doesn't exist");
        }
    });
  
  //res.send(req.body.email);
  /*var email = req.body.email;
  var password = req.body.password;
  console.log("I was in post login");
  if(email && password) {
    var resultArray;
    User.find({email : email}, function (err, docs) {
        if(err) {
            console.log(err);
        }
        if (docs.length){
            console.log('Name exists already');
            //User.find({email : email}).lean().exec(function (err, users) {
            User.find({email : email}).exec(function (err, users) {
              if(err) {
                console.log(err);
              }
              
              var myObj = JSON.parse(JSON.stringify(users));
              var myObj2 = myObj[0]
              var firstName = myObj2['firstName'];
              var lastName = myObj2['lastName'];
              var email = myObj2['email'];
              var month = myObj2['month'];
              var day = myObj2['day'];
              var year = myObj2['year'];
              var gender = myObj2['gender'];
              var password2 = myObj2['password'];
              var rating = myObj2['rating'];
              
              if(password === password2) {
                resultArray = [firstName, lastName, day, gender, email, rating, month, year];
                res.render("profile", {resultArray : resultArray});
              } else {
                res.send("wrong password");
              }
              
            });
            //res.render("alreadyExists");
            check = true;
        } else {
          res.send("Account doesn't exist");
        }
    });
  } else {
    res.send("You missed something");
  }*/
});

app.get("/getProfile", function(req, res){
  var temp = req.url.split("?");
  console.log("I was in post login");
  var temp2 = temp[1].replace("%20", "");
  console.log(temp2);
  User.find({email : temp2}, function (err, docs) {
  if(err) {
      console.log(err);
  }
  if (docs.length){
      console.log('Name exists already');
      //User.find({email : email}).lean().exec(function (err, users) {
      User.find({email : temp2}).exec(function (err, users) {
        if(err) {
          console.log(err);
        }
        
        var myObj = JSON.parse(JSON.stringify(users));
        var myObj2 = myObj[0]
        var firstName = myObj2['firstName'];
        var lastName = myObj2['lastName'];
        var email = myObj2['email'];
        var month = myObj2['month'];
        var day = myObj2['day'];
        var year = myObj2['year'];
        var gender = myObj2['gender'];
        var password2 = myObj2['password'];
        var rating = myObj2['rating'];
        
        
        var resultArray = [firstName, lastName, day, gender, email, rating, month, year];
        res.render("profile", {resultArray : resultArray});
        
      });
      //res.render("alreadyExists");
      check = true;
  } else {
    res.send("Account doesn't exist");
  }
});
});

app.post("/login", function(req, res) {
  var email = req.body.email;
  var password = req.body.password;
  console.log("I was in post login");
  if(email && password) {
    var resultArray;
    User.find({email : email}, function (err, docs) {
        if(err) {
            console.log(err);
        }
        if (docs.length){
            console.log('Name exists already');
            //User.find({email : email}).lean().exec(function (err, users) {
            User.find({email : email}).exec(function (err, users) {
              if(err) {
                console.log(err);
              }
              
              var myObj = JSON.parse(JSON.stringify(users));
              var myObj2 = myObj[0]
              var firstName = myObj2['firstName'];
              var lastName = myObj2['lastName'];
              var email = myObj2['email'];
              var month = myObj2['month'];
              var day = myObj2['day'];
              var year = myObj2['year'];
              var gender = myObj2['gender'];
              var password2 = myObj2['password'];
              var rating = myObj2['rating'];
              
              if(password === password2) {
                resultArray = [firstName, lastName, day, gender, email, rating, month, year];
                res.render("profile", {resultArray : resultArray});
              } else {
                res.send("wrong password");
              }
              
            });
            //res.render("alreadyExists");
            check = true;
        } else {
          res.send("Account doesn't exist");
        }
    });
  } else {
    res.send("You missed something");
  }
});


app.get("/fbprofile", function(req, res) {
  var temp = req.url.split("?");
  
  var temp2 = temp[1];
  var temp3 = temp2.split("&");
  var firstName = (temp3[0].split("="))[1];
  var lastName = (temp3[1].split("="))[1];
  var fbID = (temp3[2].split("="))[1];
  var gender = (temp3[3].split("="))[1];
  var email = (temp3[4].split("="))[1];
  email = email.replace("%40", "@");
  
  User.find({fbID : fbID}, function (err, docs) {
        if(err) {
            console.log(err);
        }
        if (docs.length){
            console.log('Name exists already');
            res.send("An account is already tied with this Facebook ID. Please login");
            //res.render("alreadyExists");
            check = true;
        } else {
          User.create(
          {
            name: firstName + " " + lastName,
            fbID : fbID,
            gender : gender,
            email : email,
            rating : 0
          }, function(err, user) {
            if(err) {
              console.log(err);
            } else {
              console.log("Created a new user");
              console.log(user);
              var resultArray = [firstName, lastName, fbID, gender, email, 0];
              res.render("profile", {resultArray : resultArray});
            }
          });
        }
    });
  
  
  //console.log(firstName + "\n" + lastName + "\n" + fbID + "\n" + gender + "\n" + email);
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