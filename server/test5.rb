#!/usr/bin/ruby -w

require_relative 'account'

# Log in
john = login("johndoe")
jane = login("janedoe")

# Print Real Names
puts "John: #{john.getRealname()}"
puts "Jane: #{jane.getRealname()}"
puts ""

# Print Scores
puts "John: #{john.getScore()}"
puts "Jane: #{jane.getScore()}"
puts ""

# Begin a game
john.gameStart(jane)
jane.gameStart(john)

# Game ends
john.gameLost()
jane.gameWon()

# Print Scores Again
puts "John: #{john.getScore()}"
puts "Jane: #{jane.getScore()}"
puts ""

# Log out
john.logout()
jane.logout()

# Log in
john = login("johndoe")
jane = login("janedoe")

# Print Scores Again
puts "John: #{john.getScore()}"
puts "Jane: #{jane.getScore()}"
puts ""

# Print John's Friends List
john_friends = john.getFriendsList()
puts "--------friends--------"
if john_friends != nil then
	for i in 0..(john_friends.size - 1)
		puts "FRIEND: #{john_friends[i].getRealname()}"
	end
end
puts ""

# John sends friend request to Jane
john.requestFriend("janedoe")

# Jane accepts John's friend request
jane.acceptFriend("johndoe")


# Print John's Friends List
john_friends = john.getFriendsList()
puts "--------friends--------"
if john_friends != nil then
    for i in 0..(john_friends.size - 1)
        puts "FRIEND: #{john_friends[i].getRealname()}"
    end
end
puts ""

# John removes Jane as a friend
john.removeFriend("janedoe")

# Print John's Friends List
john_friends = john.getFriendsList()
puts "--------friends--------"
if john_friends != nil then
    for i in 0..(john_friends.size - 1)
        puts "FRIEND: #{john_friends[i].getRealname()}"
    end
end
puts ""

# Log out
john.logout()
jane.logout()