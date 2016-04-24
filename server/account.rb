#!/usr/bin/ruby -w

require_relative 'access_account'
require_relative 'friend'
require_relative 'score'


# Public: Called as a player logs in
#
# _username - Username of player logging in
#
# Returns Account object of player
#
def login(_username)
	account = getAccount(_username)
	account.docAccount(account)
	return account
end


#Account Object
class Account
	begin
		# Array containing base 10 ids of all players online
		@@players_online = Array.new

		# Total number of indices allocated in @@players_online
		@@players_array_size = 16

		# Array containing Account Objects online
		@@accounts_online = Array.new

		# Total number of indices allocated in @@accounts_online
		@@accounts_array_size = 16

		# class variable tracking total number of accounts online
		@@num_of_players_online = 0
	end


	# Public: Documents Account object
	#
	# _account - Account to document
	#
	# Returns nothing
	#
	def docAccount(_account)
		account_in_array = false
		for i in 0..(@@accounts_array_size - 1)
			if @@accounts_online[i] == nil
				@@accounts_online[i] = _account
				account_in_array = true
				break
			end
		end

		# Create a larger Array if the account could not be added
		if !account_in_array
			if @@num_of_players_online + 1 == @@accounts_array_size
				temp_array = Array.new(@@accounts_array_size * 2)
				for i in 0..(@@accounts_array_size - 1)
					temp_array[i] = @@accounts_online[i]
				end
				temp_array[@@accounts_array_size] = _account
				@@accounts_array_size *= 2
				@@accounts_online = temp_array
			end
		end
	end


	# Public: Initializes Account Object
	#
	# _id - Player's unique id in base 10
	# _username - Player's username
	# _email - Player's email
	# _firstname - Player's firstname
	# _lastname - Player's lastname
	# _score - Player's current score
	# _games_played - The number of games the player has played
	# _games_won - The number of games the player has won
	# _friends_list - Array of player ids who are already friends
	# _friend_req_rec - Array of player ids who are requesting to be friends
	#
	# Returns nothing
	#
	def initialize(_id, \
			_username, \
			_email, \
			_firstname, \
			_lastname, \
			_score, \
			_games_played, \
			_games_won, \
			_friends_list, \
			_friend_req_rec)
		@id = Integer(_id)
		@username = _username
		@email = _email
		@realname = "#{_firstname} #{_lastname}"
		@score = Integer(_score)
		@games_played = Integer(_games_played)
		@games_won = Integer(_games_won)

		if _friends_list.length > 0 then
			@friends_list = _friends_list
		else
			@friends_list = Array.new(0)
		end

		if _friend_req_rec.length > 0 then
			@friend_req_rec = _friend_req_rec
		else
			@friend_req_rec = Array.new(0)
		end

		account_in_array = false
		for i in 0..(@@players_array_size - 1)
			if @@players_online[i] == nil
				@@players_online[i] = _id
				account_in_array = true
				break
			end
		end

		# Create a larger Array if the account could not be added
		if !account_in_array
			if @@num_of_players_online + 1 == @@players_array_size
				temp_array = Array.new(@@players_array_size * 2)
				for i in 0..(@@players_array_size - 1)
					temp_array[i] = @@players_online[i]
				end
				temp_array[@@players_array_size] = _id
				@@players_array_size *= 2
				@@players_online = temp_array
			end
		end
		@@num_of_players_online += 1
	end


	# Returns player's id
	#
	def getId()
		return Integer(@id)
	end


	# Returns player's username
	#
	def getUsername()
		return @username
	end


	# Returns player's real name
	#
	def getRealname()
		return @realname
	end


	#
	def getGamesWon()
		return Integer(@games_won)
	end


	#
	def getGamesPlayed()
		return Integer(@games_played)
	end


	# Public: Returns the score of the player
	#
	# Returns the score of the player
	#
	def getScore()
		return Integer(@score)
	end


	# Public: Called when the player starts a game
	#
	# _opponent_score - Score of opponent
	#
	# Returns nothing
	#
	def gameStart(_opponent_score)
		@expected_score = prematchScores(@score, _opponent_score)
	end


	# Public: Called when the player wins a game
	#
	# Returns nothing
	#
	def gameWon()
		@games_won += 1
		@games_played += 1
		@score = postmatchScores(@score, @expected_score, @games_played, 1)
	end


	# Public: Called when the player ties a game
	#
	# Returns nothing
	#
	def gameTied()
		@games_played += 1
		@score = postmatchScores(@score, @expected_score, @games_played, 0.5)
	end


	# Public: Called when the player loses a game
	#
	# Returns nothing
	#
	def gameLost()
		@games_played += 1
		@score = postmatchScores(@score, @expected_score, @games_played, 0)
	end


	# Public: Retrieves Friends List
	#
	# Returns array of Friend Objects
	#
	def getFriendsList()
        	if @friends_list == nil then
			return nil
	        end
		friend_array = Array.new(@friends_list.length)
		for i in 0..(@friends_list.length - 1)
			friend_array[i] = Friend.new(self, @friends_list[i])
		end

		return friend_array
	end


	# Public: Retrieves Friends List as an array of player ids
	#
	# Returns array of player ids
	#
	def getFriendsListId()
		return @friends_list
	end


	# Public: Returns friend requests received
	#
	# Returns array of player ids of friend requests received
	#
	def getFriendRequests()
		if @friend_req_rec == nil then
			return nil
		end
		friend_req_array = Array.new(@friends_req_rec.length)
		for i in 0..(@friend_req_rec.length - 1)
			friend_req_array[i] = Friend.new(self, @friend_req_rec[i])
		end
	end


	# Public: Finds the Account object in the class array
	#
	# _id - Base 10 id of Account to find
	#
	# Returns Account object requested
	#
	def findAccount(_id)
	        _id = Integer(_id)
		for i in 0..(@@accounts_online.size - 1)
			if (@@accounts_online[i] != nil) && \
				(_id == @@accounts_online[i].getId()) then
				return @@accounts_online[i]
			end
		end
	        return nil
	end


	# Public: Removes _friend from friends list
	#
	# _friend - username of friend to remove
	#
	# Returns nothing
	#
	def removeFriend(_friend)
		#Get base 10 id of friend
		friend_id = findId(_friend)

		destroyFriendship(friend_id, @id)
	end


	# Public: Called to make a friend request
	#
	# _player - username of friend to request
	#
	# Returns nothing
	#
	def requestFriend(_player)
		# Get base 10 id of _player
		player_id = findId(_player)

		makeFriendRequest(player_id, @id)
	end


	# Public: Called to accept friend request
	#
	# _player - username of player to accept friend request
	#
	# Returns nothing
	#
	def acceptFriend(_player)
		# Get base 10 id of _player
		player_id = findId(_player)

		acceptFriendRequest(player_id, @id)
	end


	# Public: Called to deny friend request
	#
	# _player - username of player to deny friend request
	#
	# Returns nothing
	#
	def denyFriend(_player)
		# Get base 10 id of _player
		player_id = findId(_player)

		denyFriendRequest(player_id, @id)
	end


	# Provides the number of online accounts
	#
	# Returns number of online players
	#
	def getAccountsOnline()
		return Integer(@@num_of_players_online)
	end


	# Public: Tells whether a certain account is online
	#
	# _id - base 10 id of account in question
	#
	# Returns true if _id account is online, false otherwise
	#
	def isOnline(_id)
        	_id = Integer(_id)
		for i in 0..(@@players_online.size - 1)
			if (@@players_online[i] != nil) && (_id == Integer(@@players_online[i])) then
				return true
			end
		end
		return false
	end


	# Public: Called when a player logs out
	#
	# Returns nothing
	#
	def logout()
		for i in 0..(@@players_online.size - 1)
			if (@@players_online[i] != nil) && (Integer(@@players_online[i]) == Integer(@id)) then
				@@players_online[i] = nil
				break
			end
		end
		updateAccount(findAccount(@id))
		for i in 0..(@@accounts_online.size - 1)
			if (@@accounts_online[i] != nil) && \
					(Integer(@@accounts_online[i].getId()) == Integer(@id))
				@@accounts_online[i] = nil
				break
			end
		end
		@@num_of_players_online -= 1
	end
end
