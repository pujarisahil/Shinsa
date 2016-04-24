#!/usr/bin/ruby -w

require_relative 'access_account'

#Friend Object
class Friend
	def initialize(_account, _id)
		@id = _id
		friend_data = getFriend(_id)
		@username = friend_data[0]
		@realname = "#{friend_data[1]} #{friend_data[2]}"
		@score = friend_data[3]
		@online = _account.isOnline(_id)
	end


	# Public: Returns username of Friend
	#
	# Returns Friend's username
	#
	def getUsername()
		return @username
	end


	# Public: Returns real name of Friend
	#
	# Returns Friend's real name
	#
	def getRealname()
		return @realname
	end


	# Returns score of Friend
	#
	# Returns Friend's score
	#
	def getScore()
		return @score
	end


	# Returns online status of Friend
	#
	# Returns true if Friend is online, false otherwise
	#
	def getOnline()
		return @online
	end
end
