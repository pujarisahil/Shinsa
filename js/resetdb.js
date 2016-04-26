var mysql = require('mysql');
var dbconfig = require('db_info');

var connection = mysql.createConnection(dbconfig.connection);

connection.query("DROP TABLE accounts; \
		DROP TABLE friends; \
		DROP TABLE loggedin; \
		DROP TABLE logs;");

connection.query("CREATE TABLE accounts ( \
		id INT, \
	        username VARCHAR(50), \
	        password VARCHAR(200), \
	        firstname VARCHAR(30), \
	        lastname VARCHAR(30), \
	        score INTEGER, \
	        games_played INTEGER, \
	        games_won INTEGER); \
		\
		CREATE TABLE friends ( \
		requester INTEGER, \
	        receiver INTEGER, \
	        status INT(1)); \
		\
		CREATE TABLE loggedin ( \
		id INT, \
        	username VARCHAR(20), \
        	cookie VARCHAR(200)); \
		\
		CREATE TABLE logs ( \
		timestamp TIMESTAMP(), \
        	player1 INT, \
        	player2 INT);");

connection.end();
