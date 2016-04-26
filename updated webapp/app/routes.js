module.exports = function(app, passport) {
    app.get("/", function(req, res) {
        res.render("landing");
    });
    
    /*
    * Routes to the register page which is the account creation page
    */
    app.get("/register", function(req, res) {
      res.render('login.ejs', { message: req.flash('signupMessage') });
    });
    
    app.get("/profile", isLoggedIn, function(req, res) {
      res.render('profile.ejs', {
			  user : req.user
		  });
    });
    
    app.post('/register', passport.authenticate('local-signup', {
  		  successRedirect : '/profile', // redirect to the secure profile section
  		  failureRedirect : '/login', // redirect back to the signup page if there is an error
  		  failureFlash : true // allow flash messages
  	  }));
    
    /*
    * Routes to the login page
    */
    app.get("/login", function(req, res) {
      res.render("login");
    });
    
    app.post('/login', passport.authenticate('local-login', {
            successRedirect : '/profile', // redirect to the secure profile section
            failureRedirect : '/login', // redirect back to the signup page if there is an error
            failureFlash : true // allow flash messages
		}),
        function(req, res) {
            
    
    });
    
    
    app.get("/inbox", isLoggedIn, function(req, res) {
      res.render('inbox.ejs', {
			  user : req.user
		  });
    });
    
    app.get("/friends", isLoggedIn, function(req, res) {
      
      res.render('friends.ejs', {
			  user : req.user
		  });
    });
    
    
    app.get("/friendRequests", isLoggedIn, function(req, res) {
      res.render('friendRequests.ejs', {
			  user : req.user
		  });
      
    });
    
    app.get("/tutorial", isLoggedIn, function(req, res) {
      
      res.render('tutorial.ejs', {
			  user : req.user
		  });
      
    });
    
    app.get("/gamelogs", isLoggedIn, function(req, res) {
      res.render('gamelogs.ejs', {
			  user : req.user
		  });
      
    });
    
    app.get("/leaderboard", isLoggedIn, function(req, res) {
      res.render('leaderboard.ejs', {
			  user : req.user
		  });
      
    });
    
    app.get("/groups", isLoggedIn, function(req, res) {
      res.render('groups.ejs', {
			  user : req.user
		  });
      
    });
    
    app.get("/users", isLoggedIn, function(req, res) {
      res.render('users.ejs', {
			  user : req.user
		  });
    });
    
    app.get("/play", isLoggedIn, function(req, res) {
      res.render('play.ejs', {
			  user : req.user
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
	res.redirect('/login');
}