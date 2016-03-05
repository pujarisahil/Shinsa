
# require_relative 'account'
# require_relative 'access_account'
# require_relative 'log'
# require_relative 'access_logs'

require_relative 'leaderboard'
require "mysql"
require_relative "db_info"

require 'sinatra'
require 'json'

# @DB_SERVER = 'localhost'
# @DB_USER = 'root'
# @DB_PASSWORD = ''
# @DB_TABLE = 'shinsa'


get '/get_leaderboard' do
  num = 50
  ranks = Array.new
  dbc = Mysql.new('localhost', 'root', '', 'shinsa')
  q = dbc.query ("SELECT * FROM shinsa.accounts WHERE rank <= #{num} ORDER BY rank ASC")

  js = {}
  q.each_hash do |h|
    js.update({h['username'] => h['rank']})
  end

  js.to_json
end


# CREATE TABLE accounts
# (
# username varchar(255),
# rank int,
# );

# INSERT INTO shinsa.accounts VALUES ("alice", 10);
