#!/usr/bin/ruby -w

require "mysql"
require_relative "account"
require_relative "db_info"

#
def getAccount(username)
	begin
		dbc = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, @DB_TABLE)
		#puts 'Database Connected'
		rs = dbc.query("SELECT * FROM accounts WHERE username='#{username}';")
		row = rs.fetch_row
		firstname = row[1] 
		lastname = row[2]
		rank = row[3]
		games_played = row[4]
		games_won = row[5]
		return Account.new(username, firstname, lastname, rank, games_played, games_won)
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end

def setRank(username, rank)
	begin
                dbc = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, @DB_TABLE)
                #puts 'Database Connected'
                dbc.query("UPDATE accounts SET rank='#{rank}' WHERE username='#{username}';")
        rescue Mysql::Error => e
                puts "ERROR"
                puts "Error Code: #{e.errno}"
                puts "Error Message: #{e.error}"
        ensure
                dbc.close if dbc
        end
end

def setGamesPlayed(username, num)
        begin
                dbc = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, @DB_TABLE)
                #puts 'Database Connected'
                dbc.query("UPDATE accounts SET games_played='#{num}' WHERE username='#{username}';")
        rescue Mysql::Error => e
                puts "ERROR"
                puts "Error Code: #{e.errno}"
                puts "Error Message: #{e.error}"
        ensure
                dbc.close if dbc
        end

end

def setGamesWon(username, num)
        begin
                dbc = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, @DB_TABLE)
                #puts 'Database Connected'
                dbc.query("UPDATE accounts SET games_won='#{num}' WHERE username='#{username}';")
        rescue Mysql::Error => e
                puts "ERROR"
                puts "Error Code: #{e.errno}"
                puts "Error Message: #{e.error}"
        ensure
                dbc.close if dbc
        end

end
