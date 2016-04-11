#!/usr/bin/ruby -w

@DB_SERVER = 'localhost'
@DB_USER = 'root'
@DB_PASSWORD = ''
@DB_DATABASE = 'shinsa'

DB_SERVER = 'localhost'
DB_USER = 'root'
DB_PASSWORD = ''
DB_DATABASE = 'shinsa'

@TESTDATA = true

@accounts_schema = "accounts (
	id INT,
  username VARCHAR(50),
  password VARCHAR(200),
	firstname VARCHAR(30),
	lastname VARCHAR(30),
	score INTEGER,
	games_played INTEGER,
	games_won INTEGER,
	friends_list VARCHAR(500),
	friend_req_made VARCHAR(50),
	friend_req_rec VARCHAR(50),
	friend_req_acc VARCHAR(50),
	friend_req_den VARCHAR(50)
)"

@loggedin_schema = "loggedin (
	id INT,
	username VARCHAR(20),
	cookie VARCHAR(200)
)"
