#!/usr/bin/ruby -w

require_relative 'db_info'
require_relative 'access_account'


# Public: Search for players
#
# _query - search query to find players
#
# Returns array of Friend objects of possible matches
#
def searchPlayers(_query)
	begin
		dbc = Mysql.new(DB_SERVER, DB_USER, DB_PASSWORD, DB_DATABASE)
		rs = dbc.query("SELECT id FROM accounts WHERE username \
			LIKE '#{_query}%';")
		results = Array.new
		while row = rs.fetch_row do
			results.push(row[0])
		end
		rs = dbc.query("SELECT id FROM accounts WHERE firstname \
			LIKE '#{_query}%';")
		firstnames = Array.new
		while row = rs.fetch_row do
			firstnames.push(row[0])
		end
		if firstnames != nil then
			for i in 0..(firstnames.size - 1)
				unique = true
				for j in 0..(results.size - 1)
					if firstnames[i].eql?results[j] then
						unique = false
						break
					end
				end
				if unique then
					results.push(firstnames[i])
				end
			end
		end
		rs = dbc.query("SELECT id FROM accounts WHERE lastname \
			LIKE '#{_query}%';")
		lastnames = Array.new
		while row = rs.fetch_row do
			lastnames.push(row[0])
		end
		if lastnames != nil then
			for i in 0..(lastnames.size - 1)
				unique = true
				for j in 0..(results.size - 1)
					if lastnames[i].eql?results[j] then
						unique = false
						break
					end
				end
				if unique then
					results.push(lastnames[i])
				end
			end
		end
		if results == nil then
			return nil
		end
		matches = Array.new(results.size)
		for i in 0..(results.size - 1)
			matches[i] = getFriend(results[i])
		end
		return matches
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end
