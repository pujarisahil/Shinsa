var mysql = require('mysql');
var dbconfig = require('../config/database');
var connection = mysql.createConnection(dbconfig.connection);
var nodemailer = require('nodemailer');
var async = require('async');
var crypto = require('crypto');
var sendgrid = require('sendgrid')(
  process.env.SENDGRID_API_KEY || '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'
);
var bcrypt = require('bcrypt-nodejs');


connection.connect(function(err) {
  if (err) throw err
  console.log('You are now connected again...')
})

connection.query('USE ' + dbconfig.database);

module.exports = function(app, passport) {
  app.get("/", function(req, res) {
    res.render("landing");
  });
  app.get('/login/facebook',
    passport.authenticate('facebook'));

  app.get('/login/facebook/return',
    passport.authenticate('facebook', {
      failureRedirect: '/login'
    }),
    function(req, res) {
      res.redirect('/');
    });

  /*
   * Routes to the register page which is the account creation page
   */
  app.get("/register", function(req, res) {
    res.render('login.ejs', {
      message: req.flash('signupMessage')
    });
  });

  app.get("/profile", isLoggedIn, function(req, res) {
    console.log(res.profile);
    connection.query("SELECT COUNT(score) FROM accounts WHERE score>=" + req.user.score + ";", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {
        connection.query("SELECT requester FROM friends WHERE receiver=" + req.user.id + " AND status=1;", function(err, rows2) {
          if (err)
            console.log(err);
          if (rows2.length) {
            res.render('profile.ejs', {
              user: req.user,
              rank: rows[0]['COUNT(score)'],
              numRequests: rows2.length
            });
          }
          else {
            res.render('profile.ejs', {
              user: req.user,
              rank: rows[0]['COUNT(score)'],
              numRequests: rows2.length
            });
          }
        });
      }
      else {
        res.render('profile.ejs', {
          user: req.user,
          rows: rows
        });
      }
    });
  });

  app.post('/register', passport.authenticate('local-signup', {
    successRedirect: '/profile', // redirect to the secure profile section
    failureRedirect: '/login', // redirect back to the signup page if there is an error
    failureFlash: true // allow flash messages
  }));

  /*
   * Routes to the login page
   */
  app.get("/login", function(req, res) {
    res.render("login");
  });

  app.post('/login', passport.authenticate('local-login', {
      successRedirect: '/profile', // redirect to the secure profile section
      failureRedirect: '/login', // redirect back to the signup page if there is an error
      failureFlash: true // allow flash messages
    }),
    function(req, res) {


    });


  app.get("/inbox", isLoggedIn, function(req, res) {
    connection.query("SELECT * FROM messages WHERE ofUser = ?", [req.user.username], function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {
        res.render('inbox.ejs', {
          user: req.user,
          rows: rows
        });
      }
      else {
        res.render('inbox.ejs', {
          user: req.user,
          rows: rows
        });
      }
    });
  });



  app.get("/friends", isLoggedIn, function(req, res) {

    connection.query("SELECT * FROM accounts WHERE id IN (SELECT requester FROM friends WHERE receiver=" + req.user.id + " AND status=0 UNION SELECT receiver FROM friends WHERE requester=" + req.user.id + " AND status=0);", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {
        res.render('friends.ejs', {
          user: req.user,
          rows: rows
        });
      }
      else {
        res.render('friends.ejs', {
          user: req.user,
          rows: rows
        });
      }
    });
  });


  app.get("/friendRequests", isLoggedIn, function(req, res) {

    connection.query("SELECT * FROM accounts WHERE id IN (SELECT requester FROM friends WHERE receiver=" + req.user.id + " AND status=1);", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {
        res.render('friendRequests.ejs', {
          user: req.user,
          rows: rows
        });
      }
      else {
        res.render('friendRequests.ejs', {
          user: req.user,
          rows: rows
        });
      }
    });

  });

  app.get("/tutorial", isLoggedIn, function(req, res) {

    res.render('tutorial.ejs', {
      user: req.user
    });
  });

  app.get("/gamelogs", isLoggedIn, function(req, res) {
    connection.query("SELECT * FROM logs;", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {

        res.render('gamelogs.ejs', {
          user: req.user,
          rows: rows
        });
      }
      else {

        res.render('gamelogs.ejs', {
          user: req.user,
          rows: rows
        });
      }
    });



  });

  app.get("/leaderboard", isLoggedIn, function(req, res) {
    connection.query("SELECT username FROM accounts ORDER BY score DESC", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {

        res.render('leaderboard.ejs', {
          user: req.user,
          rows: rows
        });
      }
      else {

        res.render('leaderboard.ejs', {
          user: req.user,
          rows: rows
        });
      }
    });


  });

  app.get("/groups", isLoggedIn, function(req, res) {
    
    connection.query("SELECT * FROM groups;", function(err, rows2) {
        if(err) console.log(err);
          res.render('groups.ejs', {
          user: req.user,
          rows: rows2
        });
    });
  

  });

  app.get("/users", isLoggedIn, function(req, res) {
    connection.query("SELECT * FROM accounts;", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {
        res.render('users.ejs', {
          user: req.user,
          rows: rows
        });
      }
      else {
        res.render('users.ejs', {
          user: req.user
        });
      }
    });


  });

  app.get("/getProfile?", isLoggedIn, function(req, res) {
    var tempUrl = req.url;
    tempUrl = tempUrl.split("?");
    tempUrl = tempUrl[1];

    var profileOf = tempUrl;
    var scoreTemp;

    connection.query("SELECT score FROM accounts WHERE username=" + "\"" + profileOf + "\"" + ";", function(err, rows2) {
      if (err)
        console.log(err);
      if (rows2.length) {
        scoreTemp = rows2[0]['score'];
        console.log("Temp score is " + scoreTemp);
      }
      else {

      }
    });


    connection.query("SELECT username, id, firstname, lastname, score FROM accounts WHERE username=" + "\"" + profileOf + "\"" + " LIMIT 1;", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {
        connection.query("SELECT COUNT(score) FROM accounts WHERE score>=" + scoreTemp + ";", function(err, rows2) {
          if (err)
            console.log(err);
          if (rows.length) {
            res.render('getProfile.ejs', {
              user: req.user,
              rank: rows2[0]['COUNT(score)'],
              rows: rows
            });
          }
          else {
            res.render('getProfile.ejs', {
              user: req.user,
              rank: rows[0]['COUNT(score)'],
              rows: rows
            });
          }
        });

      }
      else {
        res.render('getProfile.ejs', {
          user: req.user,
          rank: 0,
          rows: rows
        });
      }
    });
  });

  app.get("/sendRequest?", function(req, res) {
    var tempUrl = req.url;
    tempUrl = tempUrl.split("?");
    tempUrl = tempUrl[1].split("&");
    var profileOf = tempUrl[0];
    var profileId = tempUrl[1];



    connection.query("SELECT COUNT(status) FROM friends WHERE (requester=" + "\"" + profileId + "\"" + " AND receiver=" + "\"" + req.user.id + "\"" + ") OR (requester=" + "\"" + req.user.id + "\"" + " AND receiver=" + "\"" + profileId + "\"" + ");", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {
        if (rows[0]['COUNT(status)'] != 0) {
          res.redirect("/profile");
        }
        else {
          connection.query("INSERT INTO friends VALUES(" + "\"" + req.user.id + "\"" + ", " + "\"" + profileId + "\"" + ", 1);", function(err, rows2) {
            if (err)
              console.log(err)
            if (rows2.length) {;
            }
            else {
              console.log("Added friend");
            }
          });
        }
      }
      else {

      }
    });
  });

  app.get("/acceptRequest?", function(req, res) {
    var tempUrl = req.url;
    tempUrl = tempUrl.split("?");
    tempUrl = tempUrl[1].split("&");
    var profileOf = tempUrl[0];
    var profileId = tempUrl[1];



    connection.query("SELECT COUNT(status) FROM friends WHERE requester=" + profileId + " AND receiver=" + req.user.id + " AND status=1;", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {
        if (rows[0]['COUNT(status)'] == 1) {
          connection.query("UPDATE friends SET status=0 WHERE requester=" + profileId + " AND receiver=" + req.user.id + ";", function(err, rows2) {
            if (err)
              console.log(err);
            if (rows2.length) {

            }
            else {
              res.redirect('/friendRequests');
            }
          });
        }
      }
      else {

      }
    });

  });

  app.get("/sendMessage", isLoggedIn, function(req, res) {
    var tempUrl = req.url;
    tempUrl = tempUrl.split("?");
    tempUrl = tempUrl[1];

    var profileOf = tempUrl;
    res.render('sendMessage.ejs', {
      user: req.user,
      profileOf: profileOf
    });

  });

  app.post("/sendMessage", function(req, res) {
    var tempUrl = req.url;
    tempUrl = tempUrl.split("?");
    tempUrl = tempUrl[1];

    var profileOf = tempUrl;
    var message = req.body.theMessage;

    connection.query("INSERT INTO messages VALUES(" + "\"" + profileOf + "\"" + ", " + "\"" + req.user.username + "\"" + ", " + "\"" + message + "\"" + ", NOW());", function(err, rows2) {
      if (err)
        console.log(err);

      // if(rows2.length) {
      //   console.log("Message sent");
      // } else {
      //   console.log("Message sent");
      // }
    });

    res.redirect("/profile");
  });

  app.get("/play", isLoggedIn, function(req, res) {
    res.render('play.ejs', {
      user: req.user
    });
  });
  /*
   * Routes to the leaderboard page
   */
  app.get("/leaderboard", isLoggedIn, function(req, res) {
    res.render("leaderboard");
  });

  app.get("/forgotPassword", function(req, res) {
    res.render("forgotPassword", {
      user: req.user
    });
  });

  app.post("/forgotPassword", function(req, res, next) {
    async.waterfall([
      function(done) {
        crypto.randomBytes(20, function(err, buf) {
          var token = buf.toString('hex');
          done(err, token);
        });
      },
      function(token, done) {
        connection.query("SELECT email FROM accounts WHERE email=\"" + req.body.email + "\";", function(err, rows) {
          if (err)
            console.log(err);
          if (rows.length == 0) {
            req.flash('error', 'No account with that email address exists.');
            return res.redirect('/forgotPassword');
          }
          else {
            connection.query("UPDATE accounts SET resetPasswordToken=\"" + token + "\",resetPasswordExpires=" + (Date.now() + 3600000) + " WHERE email=\"" + req.body.email + "\";");
            done(err, token);
          }
        });
      },
      function(token, done) {
        sendgrid.send({
          from: 'kwresch@purdue.edu',
          to: req.body.email,
          subject: 'Password Reset',
          text: 'You are receiving this because you have requested the reset of the password for your account.\n\n' +
            'Please click on the following link, or paste this into your browser to complete the process:\n\n' +
            'http://' + req.headers.host + '/resetPassword/' + token + '\n\n' +
            'If you did not request this, please ignore this email and your password will remain unchanged.\n'
        }, function(err, json) {
          if (err) {
            console.log(err);
          }
          else {
            console.log(json);
            req.flash('info', 'An e-mail has been sent to ' + req.body.email + ' with further instructions.');
            done(err, 'done');
          }
        });
      }
    ], function(err) {
      if (err) return next(err);
      res.redirect('/forgotPassword');
    });
  });

  app.get('/resetPassword/:token', function(req, res) {
    console.log("resetPassword()");
    var temp = req.url.split("/");
    console.log(temp);
    connection.query("SELECT resetPasswordExpires FROM accounts WHERE resetPasswordToken=\"" + req.params.token + "\";", function(err, rows) {
      console.log("rows.length: " + rows.length);
      if (err)
        console.log(err);
      if (rows.length == 0 || rows[0]['resetPasswordExpires'] < Date.now()) {
        req.flash('error', 'Password reset token is invalid or has expired.');
        return res.redirect('/forgotPassword');
      }
      else {
         res.render('resetPassword.ejs', {
          token : temp[2]
        });
      }
    });
  });

  app.post("/resetPassword/:token", function(req, res) {
    console.log("resetPassword Post");
    async.waterfall([
      function(done) {
        connection.query("SELECT email,username,resetPasswordExpires FROM accounts WHERE resetPasswordToken=\"" + req.params.token + "\";", function(err, rows) {
          if (err)
            console.log(err);
          if (rows.length == 0 || rows[0]['resetPasswordExpires'] < Date.now()) {
            req.flash('error', 'Password reset token is invalid or has expired.');
            return res.redirect('/forgotPassword');
          }
          else {
            if(req.body.password1 === req.body.password2)
            connection.query("UPDATE accounts SET password=\"" + bcrypt.hashSync(req.body.password1, null, null) + "\",resetPasswordToken=NULL,resetPasswordExpires=NULL WHERE username=\"" + rows[0]['username'] + "\";");
            else
            res.send("Passwords entered do not match");
          }
          res.redirect("/login");
        });
      },
      function(rows, done) {
        sendgrid.send({
          from: 'kwresch@purdue.edu',
          to: rows[0]['email'],
          subject: 'Your password has been changed',
          text: 'Hello,\n\n' +
            'This is a confirmation that the password for your account ' + rows[0]['email'] + ' has just been changed.\n'
        }, function(err, json) {
          if (err) {
            console.log(err);
          }
          else {
            console.log(json);
            req.flash('success', 'Success! Your password has been changed.');
            done(err);
          }
        });
      }
    ], function(err) {
      res.redirect('/');
    });
  });

  app.post("/makeGroup", isLoggedIn, function(req, res) {
    var toAdd = req.body.userToAdd;
    var groupNumber = req.body.groupNumber;
    connection.query("SELECT * FROM groups WHERE member=\"" + toAdd + "\";", function(err, rows) {
      if (err)
        console.log(err);
      if (rows.length) {
        res.render('alreadyExists.ejs', {
          user: req.user
        });
      }
      else {
        connection.query("INSERT INTO groups VALUES(\"" + groupNumber + "\", \"" + toAdd + "\");", function(err2, rows2) {
          if (err2) console.log(err2);
          res.redirect("/groups");
        });
      }
    });
  });
  
  
}

function isLoggedIn(req, res, next) {
  if (req.isAuthenticated())
    return next();
  console.log("I was executed");
  // res.redirect('/login');
}