#!/usr/bin/ruby -w

require_relative 'account'
require_relative 'access_account'
require_relative 'log'
require_relative 'access_logs'
require_relative 'leaderboard'

#Test Account
account = getAccount("johndoe")
#account2 = getAccount("player2")

puts ""
puts "Username: #{account.getUsername()}"
puts "Name: #{account.getRealname()}"
puts "Score: #{account.getScore()}"
puts "Online: #{account.getOnlineStatus()}"
puts "Number of Players Online: #{account.getAccountsOnline()}"
puts ""

#Test Logs
log = Log.new("Alice", "Bob")
log.addToLog("Alice", 1, 10, 11)
log.addToLog("Bob", 8, 25, 26)
log.addToLog("Alice", 2, 12, 13)
log.addToLog("Bob", 9, 28, 29)
log.setWinner("Alice")
log.setLoser("Bob")
unit = "\u03BC".encode('utf-8')
time = Time.now.usec
log.printLog()
puts ""
puts "TIME: #{Time.now.usec - time} #{unit}s"

saveLog(log)

time = Time.now.usec
newlog = getLog(0)
newlog.printLog()
puts
puts "TIME: #{Time.now.usec - time} #{unit}s"

#Reset Database
#require_relative 'resetdb'

#Test leaderboard
#rankarray = getLeaderboard(5)
#puts "----Leaderboard----"
#for i in 0..rankarray.size-1
#	puts "#{i + 1} -- #{rankarray[i]}"
#end
#puts ""
