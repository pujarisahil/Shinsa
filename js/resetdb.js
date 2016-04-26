var mysql = require('mysql');
var dbconfig = require('../config/database');

var connection = mysql.createConnection(dbconfig.connection);

connection.query("DROP TABLE IF EXISTS accounts; DROP TABLE IF EXISTS friends; DROP TABLE IF EXISTS loggedin; DROP TABLE IF EXISTS logs;");

connection.query("CREATE TABLE accounts (  id INT UNSIGNED NOT NULL AUTO_INCREMENT, username VARCHAR(50), password VARCHAR(200), email VARCHAR(50), firstname VARCHAR(30), lastname VARCHAR(30), score INTEGER, games_played INTEGER, games_won INTEGER, primary key (id)); CREATE TABLE friends(requester INTEGER, receiver INTEGER, status INT(1)); CREATE TABLE loggedin(id INT, username VARCHAR(20), cookie VARCHAR(200)); CREATE TABLE logs(timestamp TIMESTAMP, player1 INTEGER, player2 INTEGER);");

connection.end();
