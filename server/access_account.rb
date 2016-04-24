#!/usr/bin/ruby -w

require "mysql"
require_relative "db_info"
require_relative "id_convert"


# Public: Builds and returns all account data
#
# _username - username of player
#
# Returns Account Object
#
def getAccount(_username)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE)

		rs = dbc.query("SELECT * \
			FROM accounts \
			WHERE username='#{_username}';")
		row = rs.fetch_row
		id = row[0]
		email = row[2]
		firstname = row[3] 
		lastname = row[4]
		score = row[5]
		games_played = row[6]
		games_won = row[7]

		rs = dbc.query("SELECT requester \
			FROM friends \
			WHERE receiver=#{id} AND status=0;\
			\
			SELECT receiver \
			FROM friends \
			WHERE requester=#{id} AND status=0;")
		friends_list = Array.new
		while row = rs.fetch_row do
			friends_list.push(row[0])
		end

		rs = dbc.query("SELECT receiver \
			FROM friends \
			WHERE requester=#{id} AND status=1;")
		friend_req_made = Array.new
		while row = rs.fetch_row do
			friend_req_made.push(row[0])
		end

		rs = dbc.query("SELECT requester \
			FROM friends \
			WHERE receiver=#{id} AND status=1;")
		friend_req_rec = Array.new
		while row = rs.fetch_row do
			friend_req_rec.push(row[0])
		end

		return Account.new(id, \
			_username, \
			email, \
			firstname, \
			lastname, \
			score, \
			games_played, \
			games_won, \
			friends_list, \
			friend_req_rec)
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end


# Public: Updates account information on database. Commonly used at logout
#
# _account - Account Object to update database with
#
# Returns nothing
#
def updateAccount(_account)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE)

		# Set values from Account object
		id = _account.getId()
		score = _account.getScore()
		games_played = _account.getGamesPlayed()
		games_won = _account.getGamesWon()

		# Make database query with updated data
		dbc.query("UPDATE accounts SET \
			score='#{score}', \
			games_played='#{games_played}', \
			games_won='#{games_won}', \
			WHERE id='#{id}';")
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end


# Public: Retrieves the player id from a username
#
# _username - Username of player to get ID of
#
# Returns base 10 player id
#
def findId(_username)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE)_
		rs = dbc.query("SELECT id \
			FROM accounts \
			WHERE username='#{_username}';")
		row = rs.fetch_row
		id = row[0]
		return Integer(id)

	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end


# Public: Obtains Friend data from database
#
# _id - Base 10 player id of friend
#
# Returns array of Friend data
# [0] - Friend's username
# [1] - Friend's firstname
# [2] - Friend's lastname
# [3] - Friend's score
#
def getFriend(_id)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE)
		rs = dbc.query("SELECT username, firstname, lastname, score \
			FROM accounts \
			WHERE id='#{_id}';")
		return rs.fetch_row

	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end


# Public: Adds a requesting player's base 62 id to a receiving player's 
# 'friend_req_rec' value
#
# _playerid - Id of player receiving the friend request
# _myid - Id of player who sent the friend request
#
# Returns nothing
#
def makeFriendRequest(_playerid, _myid)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE)
		rs = dbc.query("SELECT status \
			FROM friends \
			WHERE (requester=#{_playerid} \
			AND receiver=#{_myid}) \
			OR (requester=#{_myid} \
			AND receiver=#{_playerid});")
		if rs.num_rows > 0 then
			return
		end

		rs = dbc.query("INSERT INTO friends \
			VALUES (#{_myid}, #{_playerid}, 1);")

	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end


# Public: Adjusts Database values when a friend request is accepted
#
# _playerid - Id of player who sent the friend request
# _myid	- Id of player who accepted the friend request
#
# Returns nothing
#
def acceptFriendRequest(_playerid, _myid)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE)

		rs = dbc.query("SELECT status |
			FROM friends \
			WHERE requester=#{_playerid} \
			AND receiver=#{_myid};")

		if rs.num_rows < 1 then
			return
		end

		rs = dbc.query("UPDATE friends \
			SET status=0 \
			WHERE requester=#{_playerid} \
			AND receiver=#{_myid};")
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end


# Public: Adjusts database values when a friend request is denied
#
# _playerid - Id of player who made friend request
# _myid - Id of player who denied the friend request
#
# Returns nothing
#
def denyFriendRequest(_playerid, _myid)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE)
		
		rs = dbc.query("SELECT status |
			FROM friends \
			WHERE requester=#{_playerid} \
			AND receiver=#{_myid};")

		if rs.num_rows < 1 then
			return
		end

		rs = dbc.query("DELETE FROM friends \
			WHERE requester=#{_playerid} \
			AND receiver=#{_myid};") \
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end


# Public: Removes a player's own id from another player's friends list
#
# _playerid - Id of player not requesting divorce of friendship
# _myid - Id of player requesting the divorce of friendship
#
# Returns nothing
#
def destroyFriendship(_playerid, _myid)
	begin
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE)

		rs = dbc.query("SELECT status |
			FROM friends \
			WHERE (requester=#{_playerid} \
			AND receiver=#{_myid}) \
			OR (requester=#{_myid} \
			AND receiver=#{_playerid});")

		if rs.num_rows < 1 then
			return
		end

		rs = dbc.query("DELETE FROM friends \
			WHERE (requester=#{_playerid} \
			AND receiver=#{_myid}) \
			OR (requester=#{_myid} \
			AND receiver=#{_playerid};")
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end
