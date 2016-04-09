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
	# _firstname - Player's firstname
	# _lastname - Player's lastname
	# _score - Player's current score
	# _games_played - The number of games the player has played
	# _games_won - The number of games the player has won
	# _friends_list - String of friend ids in base 62
	# _friend_req_made - String of friend requests made in base 62
	# _friend_req_rec - String of friend requests made in base 62
	# _friend_req_acc - String of accepted sent friend requests in base 62
	# _friend_req_den - String of denied sent friend requests in base 62
	#
	# Returns nothing
	#
	def initialize(_id, _username, _firstname, _lastname, _score, \
			_games_played, _games_won, _friends_list, \
			_friend_req_made, _friend_req_rec, _friend_req_acc, \
			_friend_req_den)
		@id = Integer(_id)
		@username = _username
		@realname = "#{_firstname} #{_lastname}"
		@score = Integer(_score)
		@games_played = Integer(_games_played)
		@games_won = Integer(_games_won)

		# If the friends list is not empty, split the string
		# Otherwise, create a new array
		if _friends_list != nil then
			temp_friend_list = _friends_list.split(',')
			for i in 0..(temp_friend_list.size - 1)
				@friends_list[i] = con62to10(temp_friend_list[i])
			end
		else
            		@friends_list = nil
		end

		# If the friend requests made list is not empty, split the string
		# Otherwise, create a new array
		if _friend_req_made != nil then
			temp_friend_req_made = _friend_req_made.split(',')
			for i in 0..(temp_friend_req_made.size - 1)
				@friend_req_made[i] = \
					con62to10(temp_friend_req_made[i])
			end
		else
            		@friend_req_made = nil
		end

		# If the friend requests received list is not empty, split the string
		# Otherwise, create a new array
		if _friend_req_rec != nil then
			temp_friend_req_rec = _friend_req_rec.split(',')
			for i in 0..(temp_friend_req_rec.size - 1)
				@friend_req_rec[i] = con62to10(temp_friend_req_rec[i])
			end
		else
            		@friend_req_rec = nil
		end

		# If the friend requests accepted list is not empty, split the string
		# Otherwise, create a new array
		if _friend_req_acc != nil then
			temp_friend_req_acc = _friend_req_acc.split(',')
			for i in 0..(temp_friend_req_acc.size - 1)
				@friend_req_acc[i] = con62to10(temp_friend_req_acc[i])
			end
		else
			@friend_req_acc = nil
		end

		# If the friend requests denied list is not empty, split the string
		# Otherwise, create a new array
		if _friend_req_den != nil then
			temp_friend_req_den = _friend_req_den.split(',')
			for i in 0..(temp_friend_req_den.size - 1)
				@friend_req_den[i] = con62to10(temp_friend_req_den[i])
			end
		else
			@friend_req_den = nil
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
	# _account - account of opponent
	#
	# Returns nothing
	#
	def gameStart(_account)
		@expected_score = prematchScores(@score, _account.getScore())
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
		friend_array = Array.new(@friends_list.size)
		for i in 0..(@friends_list.size - 1)
			friend_array[i] = Friend.new(self, con62to10(@friends_list[i]))
		end

		return friend_array
	end


	# Public: Sets Friends List
	#
	# _friends_list - Updated friends list
	#
	# Returns nothing
	#
	def setFriendsList(_friends_list)
		@friends_list = _friends_list
	end


	# Public: Retrieves Friends List as an array of player ids
	#
	# Returns array of player ids
	#
	def getFriendsListId()
		return @friends_list
	end


	# Public: Returns friend requests made
	#
	# Returns array of player ids of friends requested
	#
	def getFriendReqMade()
		return @friend_req_made
	end


	# Public: Sets Friend Requests Made List
	#
	# _friend_req_made - Updated friend requests made list
	#
	# Returns nothing
	#
	def setFriendReqMade(_friend_req_made)
		@friend_req_made = _friend_req_made
	end


	# Public: Returns friend requests received
	#
	# Returns array of player ids of friend requests received
	#
	def getFriendReqRec()
		return @friend_req_rec
	end


	# Public: Sets Friend Requests Received List
	#
	# _friend_req_rec - Updated friend requests received list
	#
	# Returns nothing
	#
	def setFriendReqRec(_friend_req_rec)
		@friend_req_rec = _friend_req_rec
	end


	# Public: Returns friend requests made and accepted
	#
	# Returns array of player ids of friends requested and accepted
	#
	def getFriendReqAcc()
		return @friend_req_acc
	end


	# Public: Sets Accepted Friends List
	#
	# _friend_req_acc - Updated accepted friends list
	#
	# Returns nothing
	#
	def setFriendReqAcc(_friend_req_acc)
		@friend_req_acc = _friend_req_acc
	end


	# Public: Returns friend requests made and denied
	#
	# Returns array of player ids of friends requested and denied
	#
	def getFriendReqDen()
		return @friend_req_den
	end


	# Public: Sets Denied Friends List
	#
	# _friend_req_den - Updated denied friends list
	#
	# Returns nothing
	#
	def setFriendReqDen(_friend_req_den)
		@friend_req_den = _friend_req_den
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

		# If the player is online, adjust their Account object
		# Otherwise, adjust their database entry
		if isOnline(friend_id) then
			account = findAccount(friend_id)
			friends_array = account.getFriendsListId()
			temp_array = Array.new(friends_array.size - 1)
			j = 0
			for i in 0..(friends_array.size - 1)
				if con62to10(friends_array[i]) != @id then
					temp_array[j] = friends_array[i]
					j += 1
				end
			end
			account.setFriendsList(temp_array)
		else
			destroyFriendship(_friend, @id)
		end

		friendsSize = @friends_list.size
		new_friends = Array.new(friendsSize - 1)
		j = 0
		for i in 0..(friendsSize - 1)
			if con62to10(@friends_list[i]) != friend_id then
				new_friends[j] = @friends_list[i]
				j += 1
			end
		end
		@friends_list = new_friends
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

		# If the player is online, adjust their Account object
		# Otherwise, adjust their database entry
		if isOnline(player_id) then
			# Retrieve other player's Account
			account = findAccount(player_id)
			req_rec = account.getFriendReqRec()
            		if req_rec == nil then
                		temp_array = Array.new(1)
                		temp_array[0] = con10to62(@id)
            		else
                		temp_array = Array.new(req_rec.size + 1)
                		for i in 0..(req_rec.size - 1)
					temp_array[i] = req_rec
                		end
                		temp_array[req_rec.size] = con10to62(@id)
			end
			account.setFriendReqRec(temp_array)
		else
			makeFriendRequest(_player, @id)
		end

		# Add base 62 id of player whose friendship is requested
		if @friend_req_made == nil then
			@friend_req_made = Array.new(1)
			@friend_req_made[0] = con10to62(player_id)
		else
			temp_array = Array.new(@friend_req_made.size + 1)
			for i in 0..(@friend_req_made.size - 1)
				temp_array[i] = @friend_req_made[i]
			end
			temp_array[@friend_req_made.size] = con10to62(player_id)
			@friend_req_made = temp_array
		end
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

		# If the player is online, adjust their Account Object
		# Otherwise, adjust their database entry
		if isOnline(player_id) then
			account = findAccount(player_id)

			# Adds accepting player's base 62 id to original
			# player's 'friend_req_acc' value in their Account
			req_acc = account.getFriendReqAcc()
			if req_acc == nil then
                		temp_array = Array.new(1)
				temp_array[0] = con10to62(@id)
			else
				temp_array = Array.new(req_acc.size + 1)
				for i in 0..(req_acc.size - 1)
					temp_array[i] = req_acc[i]
				end
				temp_array[req_acc.size] = con10to62(@id)
			end
			account.setFriendReqAcc(temp_array)

			# Removes accepting player's base 62 id from original
			# player's 'freind_req_made' value in their Account
			req_made = account.getFriendReqMade()
			temp_array = Array.new(req_made.size - 1)
			j = 0
			for i in 0..(req_made.size - 1)
				if con62to10(req_made[i]) != @id then
					temp_array[j] = req_made[i]
					j += 1
				end
			end
			account.setFriendReqMade(temp_array)

			# Adds accepting player's base 62 id to original
			# player's 'friends_list' value in their Account
			f_list = account.getFriendsListId()
			if f_list == nil then
				temp_array = Array.new(1)
				temp_array[0] = con10to62(@id)
			else
				temp_array = Array.new(f_list.size + 1)
				for i in 0..(f_list.size - 1)
					temp_array[i] = f_list[i]
				end
				temp_array[f_list.size] = con10to62(@id)
			end
				account.setFriendsList(temp_array)
		else
			acceptFriendRequest(_player, @id)
		end

		# Add the asking player to this player's friends_list
		if @friends_list == nil then
            		@friends_list = Array.new(1)
			@friends_list[0] = con10to62(player_id)
		else
			temp_array = Array.new(@friends_list.size + 1)
			for i in 0..(@friends_list.size - 1)
				temp_array[i] = @friends_list[i]
			end
			temp_array[@friends_list.size] = con10to62(player_id)
			@friends_list = temp_array
		end

		# Remove the asking player from this player's friend_req_rec
		temp_array = Array.new(@friend_req_rec.size - 1)
		j = 0
		for i in 0..(@friend_req_rec.size - 1)
			if con62to10(@friend_req_rec[i]) != player_id then
				temp_array[j] = @friend_req_rec[i]
				j += 1
			end
		end
		@friend_req_rec = temp_array
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

		# If the player is online, adjust their Account Object
		# Otherwise, adjust their database entry
		if isOnline(player_id) then
			account = findAccount(player_id)

			# Add denying player's base 62 id to original
			# player's 'friend_req_den' value in the Account
			req_den = account.getFriendReqDen()
			if req_den == nil then
				temp_array = Array.new(1)
				temp_array[0] = con10to62(@id)
			else
				temp_array = Array.new(req_den.size + 1)
				for i in 0..(req_den.size - 1)
					temp_array[i] = req_den[i]
				end
				temp_array[req_den.size] = con10to62(@id)
			end
			account.setFriendReqDen(temp_array)

			# Removes accepting player's base 62 id from original
			# player's 'friend_req_made' value in the Account
			req_made = account.getFriendReqMade()
			temp_array = Array.new(req_made.size - 1)
			j = 0
			for i in 0..(req_made.size - 1)
				if con62to10(req_made[i]) != @id then
					temp_array[j] = req_made[i]
					j += 1
				end
			end
			account.setFriendReqMade(temp_array)
		else
			denyFriendRequest(_player, @id)
		end

		# Remove the asking player from this player's friend_req_rec
		temp_array = Array.new(@friend_req_rec.size - 1)
		j = 0
		for i in 0..(@friend_req_rec.size - 1)
			if con62to10(@friend_req_rec[i]) != player_id then
				temp_array[j] = @friend_req_rec[i]
				j += 1
			end
		end
		@friend_req_rec = temp_array
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
