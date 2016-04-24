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
	games_won INTEGER
)"

@friends_schema = "friends (
	requester INTEGER,
	receiver INTEGER,
	status INT(1)
)"

@loggedin_schema = "loggedin (
	id INT,
	username VARCHAR(20),
	cookie VARCHAR(200)
)"
