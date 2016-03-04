#!/usr/bin/ruby -w

#Account Object
class Account
	begin
		#class variable tracking total number of accounts online
		@@num_of_players_online = 0

		puts "Account Class Initialized"
	end

	def initialize(_username, _firstname, _lastname, _rank, _games_played, _games_won)
		@username = _username
		@realname = "#{_firstname} #{_lastname}" 
		@rank = _rank
		@online = true
		@games_played = _games_played
		@games_won = _games_won
		@@num_of_players_online += 1
	end
	
	#returns username
	def getUsername()
		return @username
	end

	#returns real name
	def getRealname()
		return @realname
	end

	#sets rank
	def setRank(new_rank)
		@rank = new_rank
	end

	#returns rank
	def getRank()
		return @rank
	end

	#sets online status
	def setOnlineStatus(onstat)
		@online = onstat
	end

	#returns online status
	def getOnlineStatus()
		return @online
	end

	#returns number of accounts online
	def getAccountsOnline()
		return @@num_of_players_online
	end

	#decreases number of players online
	def logoff()
		@@num_of_players_online -= 1
	end
end
