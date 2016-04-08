require 'sinatra'
require 'json'
require 'mysql'

require_relative 'db_info'

DB = Mysql.new(@DB_SERVER, @DB_USER, @DB_PASSWORD, @DB_DATABASE)

def db_add(table, tuple)
    query = "
      INSERT INTO #{table}
      VALUES (
      #{(tuple.map { |i| "\"#{i}\"" }).join(',')})"
    DB.query(query)
end

# in: string username, string password
# out: {'sucess': boolean, "cookie": nil or string}
post '/login' do
    # is a valid username
    begin
        username = params['username']
        password = params['password']
    rescue
        return { sucess: false, cookie: nil }.to_json
    end

    # are we already logged in
    cookie_exists = DB.query("select * from loggedin where username like \"#{username}\"").fetch_hash
    if cookie_exists
        return { sucess: true, cookie: cookie_exists['cookie'] }.to_json
    end

    # add cookie if right pass
    user = DB.query("select * from accounts where username like \"#{username}\"").fetch_hash
    if user['password'] == password
        newcookie = ('a'..'z').to_a.sample(32).join
        db_add('loggedin', [0, params['username'], newcookie])
        return { sucess: true, cookie: newcookie }.to_json
    else
        return { sucess: false, cookie: nil }.to_json
    end
end

# in: string username
# out: {'sucess': boolean}
post '/logout' do
    begin
        username = params['username']
        logout = DB.query "delete from loggedin where username like \"#{username}\""
        return { sucess: true }.to_json
    rescue
        return { sucess: false }.to_json
    end
end

# in: string username, string password
# out: {'sucess': boolean, 'error': int}
post '/create_user' do
    begin
        username = params['username']
        password = params['password']
        first = params['first'] || nil
        last = params['last'] || nil
    rescue
        return { sucess: false }.to_json
    end

    # does user already exist?
    user = DB.query("select * from accounts where username like \"#{username}\"").fetch_hash
    return { sucess: false, error: 'already exists' }.to_json if user

    # TODO: password requirements?

    begin
        db_add('accounts', [0, username, password, first, last, '', '', '', ''])
        return { sucess: true, error: nil }.to_json
    rescue
        return { sucess: false, error: 'unknown error' }.to_json
    end
end

# in: string username
# out: all json user info, null for invalid user
post '/get_user_info' do
    begin
        username = params['username']
        user = DB.query("select * from accounts where username like \"#{username}\"").fetch_hash.to_json
    rescue
        return nil.to_json
    end

    # TODO: blank out password
    return user
end

post '/start_game' do # user1 user2 -> game ID
end

post '/end_game' do # game ID -> sucess fail
end

post '/leaderboard' do # none -> leaderboard json
end
