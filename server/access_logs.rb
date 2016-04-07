#!/usr/bin/ruby -w

require "mysql"
require_relative "log"
require_relative "db_info"

def saveLog(log)
	begin
		dbc = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, 'logs')
		#puts 'Database Connected'
		result = dbc.query("SELECT * FROM log_schema;")
		row = result.fetch_row
		next_log = row[0]
		#max_logs = row[1]
		dbc.query("CREATE TABLE log#{next_log} (player VARCHAR(20), pieceid INTEGER, startpos INTEGER, endpos INTEGER)")
		dbc.query("INSERT INTO log#{next_log} VALUES ('#{log.getWinner()}', NULL, NULL, NULL);")
		dbc.query("INSERT INTO log#{next_log} VALUES ('#{log.getLoser()}', NULL, NULL, NULL);")
		num = log.getNumOfEntries()
		for i in 0..num-1
			entry = log.getEntry(i)
			dbc.query("INSERT INTO log#{next_log} VALUES ('#{entry.getPlayer()}', #{entry.getPieceId()}, #{entry.getStartPos()}, #{entry.getEndPos()});")
		end
		dbc.query("UPDATE log_schema SET next_log='#{Integer(next_log)+1}' WHERE next_log='#{next_log}';")
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end

def getLog(num)
	begin
		dbc = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, 'logs')
		#puts 'Database Connected'
		result = dbc.query("SELECT * FROM log#{num}")
		row = result.fetch_row
		winner = row[0]
		row = result.fetch_row
		loser = row[0]
		log = Log.new(winner, loser)
		log.setWinner(winner)
		log.setLoser(loser)
		n_rows = result.num_rows - 2
		n_rows.times do
			row = result.fetch_row
			log.addToLog(row[0], row[1], row[2], row[3])
		end
		#log.printLog()
		return log
	rescue Mysql::Error => e
		puts "ERROR"
		puts "Error Code: #{e.errno}"
		puts "Error Message: #{e.error}"
	ensure
		dbc.close if dbc
	end
end
