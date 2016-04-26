var mysql = require('mysql');
var dbconfig = require('db_info');

var connection = mysql.createConnection(dbconfig.connection);

connection.query("DROP TABLE accounts IF EXISTS; DROP TABLE friends IF EXISTS;DROP TABLE loggedin IF EXISTS; DROP TABLE logs IF EXISTS;");

connection.query("CREATE TABLE accounts (  id INT UNSIGNED NOT NULL AUTO_INCREMENT, username VARCHAR(50), password VARCHAR(200), email VARCHAR(50), firstname VARCHAR(30), lastname VARCHAR(30), score INTEGER, games_played INTEGER, games_won INTEGER, primary key (id));");

connection.end();
