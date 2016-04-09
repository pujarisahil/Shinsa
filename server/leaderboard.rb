#!/usr/bin/ruby -w

require "mysql"
require_relative "db_info"

#returns top 'num' players as Array
def getLeaderboard(num)
	begin
		ranks = Array.new
		dbc = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, @DB_DATABASE)
		q = dbc.query ("SELECT username FROM accounts WHERE score ORDER BY score DESC LIMIT #{num}")
		n_rows = q.num_rows
		n_rows.times do
			row = q.fetch_row
			ranks.push(row[0])
		end
		return ranks
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end
