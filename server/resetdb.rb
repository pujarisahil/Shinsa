#!/usr/bin/ruby -w

require "mysql"
require_relative "db_info"

begin
	dbc = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, 'logs')
	dbc.query("DROP TABLE log0;")
	dbc.query("UPDATE log_schema SET next_log=0 WHERE next_log=1;")
	puts ""
	puts "****Database Reset****"
	puts ""
rescue Mysql::Error => e
	puts "ERROR"
	puts "Error Code: #{e.errno}"
	puts "Error Message: #{e.error}"
ensure
	dbc.close if dbc
end
