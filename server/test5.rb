#!/usr/bin/ruby -w

require_relative 'account'

john = login("johndoe")
jane = login("janedoe")

#Print Real Names
puts "John: #{john.getRealname()}"
puts "Jane: #{jane.getRealname()}"
puts ""

#Print Scores
puts "John: #{john.getScore()}"
puts "Jane: #{jane.getScore()}"
puts ""

john.gameStart(jane)
jane.gameStart(john)

john.gameLost()
jane.gameWon()

#Print Scores Again
puts "John: #{john.getScore()}"
puts "Jane: #{jane.getScore()}"
puts ""

#john.logout()
#jane.logout()

#john = login("johndoe")
#jane = login("janedoe")

#Print Scores Again
#puts "John: #{john.getScore()}"
#puts "Jane: #{jane.getScore()}"
#puts ""

john_friends = john.getFriendsList()
puts "--------friends--------"
if john_friends != nil then
	for i in 0..(john_friends.size - 1)
		puts "FRIEND: #{john_friends[i].getRealname()}"
	end
end
puts ""
john.requestFriend("janedoe")
puts "REQUEST MADE"
jane.acceptFriend("johndoe")

john_friends = john.getFriendsList()
puts "--------friends--------"
for i in 0..(john_friends.size - 1)
	puts "FRIEND: #{john_friends[i].getRealname()}"
end
puts ""
