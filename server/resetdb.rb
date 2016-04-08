#!/usr/bin/ruby -w

require "mysql"
require_relative "db_info"

def db_add(table, tuple)
  query = "
    INSERT INTO #{table}
    VALUES (
    #{(tuple.map { |i| "\"#{i}\"" }).join(',')}
    )
  "
	puts query
	DB.query(query)
end

def db_do(query)
	puts query
	begin
		DB.query query
	rescue => e
		puts "===== ERROR ====="
		puts e
	end
end

DB = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, @DB_DATABASE)

db_do "drop table accounts"
db_do "create table #{@accounts_schema}"

if @TESTDATA
	db_add("accounts", [0, "bob",   "bobpass",   "bobby",     "bobberson", 888,    22, 5, "qbert"])
	db_add("accounts", [2, "alice", "alicepass", "alexandra", "apples",    753,    33, 6, "bob"])
	db_add("accounts", [1, "qbert", "qbertpass", "q",         "bert",      100000, 44, 7, ""])
end

db_do "drop table loggedin"
db_do "create table #{@loggedin_schema}"

if @TESTDATA
	db_add("loggedin", [1, "qbert", "testcookieno3"])
end




#
# begin
# 	dbc = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, 'logs')
# 	dbc.query("DROP TABLE log0;")
# 	dbc.query("UPDATE log_schema SET next_log=0 WHERE next_log=1;")
# 	puts ""
# 	puts "****Database Reset****"
# 	puts ""
# rescue Mysql::Error => e
# 	puts "ERROR"
# 	puts "Error Code: #{e.errno}"
# 	puts "Error Message: #{e.error}"
# ensure
# 	dbc.close if dbc
# end
