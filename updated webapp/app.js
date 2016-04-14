var express = require("express");
var app = express();
var mongoose = require("mongoose");
var bodyParser = require("body-parser");
mongoose.connect("mongodb://localhost/users");


//Allows the use of bodyParser
app.use(bodyParser.urlencoded({extended : true}));

//Schema of a User
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

//Schema of a friend request
var requestsSchema = new mongoose.Schema({
    requesterEmail: String,
    requestedOfEmail: [String],
    dateRequested: { type: Date, default: Date.now },
    timeRequested: { type : Date, default: Date.now }
});

//Schema of list of friends
var friendSchema = new mongoose.Schema({
  email1: String,
  email2: String
});

var User = mongoose.model("User", userSchema);
var FriendRequest = mongoose.model("FriendRequest", requestsSchema);
var Friend = mongoose.model("Friend", friendSchema);

app.set("view engine", "ejs");

/*
* Routes to the landing page which is the index page
*/
app.get("/", function(req, res) {
    res.render("landing");
});

/*
* Routes to the register page which is the account creation page
*/
app.get("/register", function(req, res) {
  res.render("register");
});

/*
* Handles post requests at the register page
*/
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
              res.render("profile", {resultArray : resultArray});
            }
          });
        }
    });
  } else {
    res.send("You missed something");
  }
});

/*
* Routes to the profile page when FB authentication is done
*/
app.get("/auth/facebook", function(req, res){
  res.render("profile");
});

/*
* Routes to the profile page when FB login authentication is done
*/
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
        }
    });
});

/*
* Routes to the login page
*/
app.get("/login", function(req, res) {
  res.render("login");
});

/*
* Routes to a page that contains list of all members
*/
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
            returnArray[counter] = temp[1];
            
            res.render("memberProfiles", {returnArray : returnArray});
        } else {
          res.send("Account doesn't exist");
        }
    });
});

/*
* Routes to the profile page of other members
*/
app.get("/getProfile", function(req, res){
  var temp = req.url.split("?");
  console.log("I was in post login");
  var temp2 = temp[1].replace("%20", "");
  console.log(temp2);
  var temp3 = temp2.split("&");
  temp2 = temp3[0];
  var requester = temp3[1];
  requester = requester.replace("%20", "");
  //console.log("Requester was " + requester);
  
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
        
        
        var resultArray = [firstName, lastName, day, gender, email, rating, month, year, requester];
        res.render("profile", {resultArray : resultArray});
        
      });
      check = true;
  } else {
    res.send("Account doesn't exist");
  }
});
});

/*
* Handles the POST request of credentials entered on the login page
*/
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
                resultArray = [firstName, lastName, day, gender, email, rating, month, year, email];
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

/*
* Handles the FB account creation on register page
*/
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
            firstName: firstName,
            lastName: lastName,
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

/*
* Routes to the edit-profile page
*/
app.get("/edit-profile", function(req, res) {
  res.render("editProfile");
});

app.get("/addFriend", function(req, res){
  var temp = req.url.split("?");
  var requestedOf = temp[1].replace("%20", "");
  var temp3 = requestedOf.split("&");
  requestedOf = temp3[0];
  var requester = temp3[1];
  requester = requester.replace("%20", "");
  console.log("Requester is " + requester);
  console.log("Requested of is " + requestedOf);
      FriendRequest.find({requesterEmail : requester}, function (err, docs) {
            if(err) {
              console.log(err);
            } 
            if (docs.length){
            
              console.log('Name exists already');
            
              var myObj = JSON.parse(JSON.stringify(docs));
              var myObj2 = myObj[0]
              var allRequests = myObj2['requestedOfEmail'];
              
              if (allRequests.indexOf(requestedOf) > -1) {
                res.send("You have already requested this guy");
              } else {
                allRequests.push(requestedOf);
                console.log("Requests array now has " + allRequests);
                var tempRequest = new FriendRequest({
                      requesterEmail: requester,
                      requestedOfEmail: allRequests,
                      dateRequested: { type: Date, default: Date.now },
                      timeRequested: { type : Date, default: Date.now }
                });
                
                // Convert the Model instance to a simple object using Model's 'toObject' function
                // to prevent weirdness like infinite looping...
                var upsertData = tempRequest.toObject();
                
                // Delete the _id property, otherwise Mongo will return a "Mod on _id not allowed" error
                delete upsertData._id;
                
                // Do the upsert, which works like this: If no Contact document exists with 
                // _id = contact.id, then create a new doc using upsertData.
                // Otherwise, update the existing doc with upsertData
                FriendRequest.update({requesterEmail: requester}, upsertData, {upsert: true}, function(err, docs) {
                  if(err) {
                    res.send("There was error in updating");
                  }
                });
              }
      } else {
              var allRequests = [];
              
                allRequests.push(requestedOf);
                console.log("ELSE : Requests array now has " + allRequests);
                var tempRequest = new FriendRequest({
                      requesterEmail: requester,
                      requestedOfEmail: allRequests,
                      dateRequested: { type: Date, default: Date.now },
                      timeRequested: { type : Date, default: Date.now }
                });
                
                // Convert the Model instance to a simple object using Model's 'toObject' function
                // to prevent weirdness like infinite looping...
                var upsertData = tempRequest.toObject();
                
                // Delete the _id property, otherwise Mongo will return a "Mod on _id not allowed" error
                delete upsertData._id;
                
                // Do the upsert, which works like this: If no Contact document exists with 
                // _id = contact.id, then create a new doc using upsertData.
                // Otherwise, update the existing doc with upsertData
                FriendRequest.update({requesterEmail: requester}, upsertData, {upsert: true}, function(err, docs) {
                  if(err) {
                    res.send("There was error in updating");
                  }
                });
                res.send("Done");
      }
    });
});

/*
* Routes to the leaderboard page
*/
app.get("/leaderboard", function(req, res) {
  res.render("leaderboard");
});


app.listen(process.env.PORT, process.env.IP, function() {
    console.log("It has started bro");
});