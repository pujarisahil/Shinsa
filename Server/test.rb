#!/usr/bin/ruby -w

require_relative 'account'
require_relative 'access_account'
require_relative 'log'
require_relative 'access_logs'

#Test Account
account = getAccount("johndoe")

puts account.getUsername()
puts ""

#Test Logs
log = Log.new("Alice", "Bob")
log.addToLog("Alice", 1, 10, 11)
log.addToLog("Bob", 8, 25, 26)
log.addToLog("Alice", 2, 12, 13)
log.addToLog("Bob", 9, 28, 29)
log.setWinner("Alice")
log.setLoser("Bob")
log.printLog()

saveLog(log)
newlog = getLog(0)

newlog.printLog()

#Reset Database
require_relative 'resetdb'

#Test leaderboard
rankarray = getLeaderboard(5)
puts "----Leaderboard----"
for i in 0..rankarray.size-1
        puts "#{i + 1} -- #{rankarray[i]}"
end
puts ""
