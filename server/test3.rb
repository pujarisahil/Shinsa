#!/usr/bin/ruby

require_relative 'account'
require_relative 'access_account'

account = getAccount("johndoe")

puts ""
puts "Username: #{account.getUsername()}"
puts "Name: #{account.getRealname()}"
puts "Rank: #{account.getRank()}"
puts "Online: #{account.getOnlineStatus()}"
puts "Number of Players Online: #{account.getAccountsOnline()}"
puts ""

friendsList = account.getFriendsList()

puts "Before Friends List"
for i in 0..(friendsList.size - 1)
	puts "\t#{friendsList[i]}"
end

account.addFriend("testfriend")
friendsList = account.getFriendsList()

puts "After Friends List"
for i in 0..(friendsList.size - 1)
	puts "\t#{friendsList[i]}"
end
