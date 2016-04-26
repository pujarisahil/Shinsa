var mysql = require('mysql');
var dbconfig = require('../config/database');
var connection = mysql.createConnection(dbconfig.connection);

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
  passport.authenticate('facebook', { failureRedirect: '/login' }),
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
              rows : rows
            });
      }
      else {
        res.render('friendRequests.ejs', {
              user: req.user,
              rows : rows
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
      rows : rows
    });
      }
      else {
        
        res.render('gamelogs.ejs', {
      user: req.user,
      rows : rows
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
      rows : rows
    });
      }
      else {
        
        res.render('leaderboard.ejs', {
      user: req.user,
      rows : rows
    });
      }
    });


  });

  app.get("/groups", isLoggedIn, function(req, res) {
    res.render('groups.ejs', {
      user: req.user
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
            if (rows2.length) {
              ;
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
            if(err)
              console.log(err);
            if(rows2.length) {
              
            } else {
                res.redirect('/friendRequests');
            }
          });
        }
      } else {
        
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
      profileOf : profileOf
    });
    
  });
  
  app.post("/sendMessage", function(req, res) {
    var tempUrl = req.url;
    tempUrl = tempUrl.split("?");
    tempUrl = tempUrl[1];

    var profileOf = tempUrl;
    var message = req.body.theMessage;
    
    connection.query("INSERT INTO messages VALUES(" + "\"" + profileOf + "\"" + ", "  + "\"" + req.user.username + "\"" + ", " +  "\"" +  message  + "\"" +  ", NOW());", function(err, rows2) {
       if(err)
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
}

function isLoggedIn(req, res, next) {
  if (req.isAuthenticated())
    return next();
    console.log("I was executed");
  // res.redirect('/login');
}