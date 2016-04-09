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
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_TABLE)

		rs = dbc.query("SELECT * FROM accounts WHERE \
			username='#{_username}';")
		row = rs.fetch_row
		# Base 10 id
		id = row[0]
		firstname = row[2] 
		lastname = row[3]
		score = row[4]
		games_played = row[5]
		games_won = row[6]
		# Other player ids are in base 62
		friends_list = row[7]
		friend_req_made = row[8]
		friend_req_rec = row[9]
		friend_req_acc = row[10]
		friend_req_den = row[11]
		return Account.new(id, _username, firstname, lastname, score, \
			games_played, games_won, friends_list, friend_req_made,\
			friend_req_rec, friend_req_acc, friend_req_den)
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
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_TABLE)

		# Set values from Account object
		id = _account.getId()
		score = _account.getScore()
		games_played = _account.getGamesPlayed()
		games_won = _account.getGamesWon()
		if _account.getFriendsListId() != nil then
			friends_list = _account.getFriendsListId().join(',')
		else
			friends_list = ""
		end
		if _account.getFriendReqMade() != nil then
			friend_req_made = _account.getFriendReqMade().join(',')
		else
			friend_req_made = ""
		end
		if _account.getFriendReqRec() != nil then
			friend_req_rec = _account.getFriendReqRec().join(',')
		else
			friend_req_rec = ""
		end
		if _account.getFriendReqAcc() != nil then
			friend_req_acc = _account.getFriendReqAcc().join(',')
		else
			friend_req_acc = ""
		end
		if _account.getFriendReqDen() != nil then
			friend_req_den = _account.getFriendReqDen().join(',')
		else
			friend_req_den = ""
		end

		# Make database query with updated data
		dbc.query("UPDATE accounts SET \
			score='#{score}', \
			games_played='#{games_played}', \
			games_won='#{games_won}', \
			friends_list='#{friends_list}', \
			friend_req_made='#{friend_req_made}', \
			friend_req_rec='#{friend_req_rec}', \
			friend_req_acc='#{friend_req_acc}', \
			friend_req_den='#{friend_req_den}' \
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
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_TABLE)
		rs = dbc.query("SELECT id FROM accounts WHERE \
			username='#{_username}';")
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
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_TABLE)
		rs = dbc.query("SELECT username, firstname, lastname, score \
			FROM accounts WHERE id='#{_id}';")
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
# _player - Username of player who is receiving the friend request
# _myid - Base 10 id of player who sent the friend request
#
# Returns nothing
#
def makeFriendRequest(_player, _myid)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_TABLE)
		rs = dbc.query("SELECT friend_req_rec FROM accounts WHERE \
			username='#{_player}';")
		row = rs.fetch_row
		old_queue = row[0]
		if old_queue != nil && old_queue.length != 0 then
            puts "old queue: >#{old_queue}<"
			old_queue = "#{old_queue},"
		end
		rs = dbc.query("UPDATE accounts SET friend_req_rec=\
			'#{old_queue}#{con10to62(_myid)}' WHERE username=\
			'#{_player}';")
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
# _player - Username of player who sent friend request
# _myid	- Id of player who accepted the friend request
#
# Returns nothing
#
def acceptFriendRequest(_player, _myid)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_TABLE)

		# Convert the base 10 id to base 62 for database storage
		id62 = con10to62(_myid)

		# Adds accepting player's base 62 id to original player's
		# 'friend_req_acc' value in the database
		rs = dbc.query("SELECT friend_req_acc FROM accounts WHERE \
			username='#{_player}';")
		row = rs.fetch_row
		old_req_acc = row[0]
		if old_req_acc != nil && old_req_acc.length != 0 then
			old_req_acc = "#{old_req_acc},"
		end
		dbc.query("UPDATE accounts SET friend_req_acc=\
			'#{old_req_acc}#{id62}' WHERE username=\
			'#{_player}';")
		
		# Removes accepting player's base 62 id from original player's
		# 'friend_req_made' value in the database
		rs = dbc.query("SELECT friend_req_made FROM accounts WHERE \
			username='#{_player}';")
		row = rs.fetch_row
		old_req_made = row[0].split(',')
		temp_array = Array.new(old_req_made.size - 1)
		j = 0
		for i in 0..(old_req_made.size - 1)
			if con62to10(old_req_made[i]) != _myid then
				temp_array[j] = old_req_made[i]
				j += 1
			end
		end
		new_req_made = temp_array.join(',')
		dbc.query("UPDATE accounts set friend_req_made='#{new_req_made}'\
			WHERE username='#{_player}';")

		# Adds accepting player's base 62 id to original player's
		# 'friends_list' value in the database
		rs = dbc.query("SELECT friends_list FROM accounts WHERE \
			username='#{_player}';")
		row = rs.fetch_row
		old_list = row[0]
		if old_list != nil && old_list.length != 0 then
			old_list = "#{old_list},"
		end
		dbc.query("UPDATE accounts SET friends_list='#{old_list}#{id62}' \
			WHERE username='#{_player}';")
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
# _player - Username of player who sent the friend request
# _myid - Id of player who denied the friend request
#
# Returns nothing
#
def denyFriendRequest(_player, _myid)
	begin
		# Establish connection with database
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_TABLE)
		
		# Convert the base 10 id to base 62 for database storage
		id62 = con10to62(_myid)

		# Adds accepting player's base 62 id to original player's
		# 'friend_req_den' value in the database
		rs = dbc.query("SELECT friend_req_den FROM accounts WHERE \
			username='#{_player}';")
		row = rs.fetch_row
		old_req_acc = row[0]
		if old_req_acc != nil && old_req_acc.length != 0 then
			old_req_acc = "#{old_req_acc},"
		end
		dbc.query("UPDATE accounts SET friend_req_den=\
			'#{old_req_acc}#{id62}' WHERE username=\
			'#{_player}';")

		# Removes accepting player's base 62 id from original player's
		# 'friend_req_made' value in the database
		rs = dbc.query("SELECT friend_req_made FROM accounts WHERE \
			username='#{_player}';")
		row = rs.fetch_row
		old_req_made = row[0].split(',')
		temp_array = Array.new(old_req_made.size - 1)
		j = 0
		for i in 0..(old_req_made.size - 1)
			if con62to10(old_req_made[i]) != _myid then
				temp_array[j] = old_req_made[i]
				j += 1
			end
		end
		new_req_made = temp_array.join(',')
		dbc.query("UPDATE accounts set friend_req_made='#{new_req_made}'\
			WHERE username='#{_player}';")
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
# _player - Username of player who is losing a friend
# _myid - Base 10 id of player requesting the divorce of friendship
#
# Returns nothing
#
def destroyFriendship(_player, _myid)
	begin
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_TABLE)
		rs = dbc.query("SELECT friends_list FROM accounts WHERE \
			username='#{_player}';")
		row = rs.fetch_row
		old_req_made = row[0].split(',')
		temp_array = Array.new(old_req_made.size - 1)
		j = 0
		for i in 0..(old_req_made.size - 1)
			if con62to10(old_req_made[i]) != _myid then
				temp_array[j] = old_req_made[i]
				j += 1
			end
		end
		new_req_made = temp_array.join(',')
		dbc.query("UPDATE accounts set friends_list='#{new_req_made}'\
			WHERE username='#{_player}';")
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end
