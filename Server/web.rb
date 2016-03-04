require 'sinatra'
require 'JSON'

get '/' do
  erb :index
end

get '/login' do
  erb :login
end

get '/register' do
  erb :register
end

post '/login' do
  erb :login
end

post '/register' do
  erb :register
end



# # view one
# get '/widgets/:id' do
#   widget = Widget.find(params[:id])
#   return status 404 if widget.nil?
#   widget.to_json
# end
#
# # create
# post '/widgets' do
#   widget = Widget.new(params['widget'])
#   widget.save
#   status 201
# end
#
# # update
# put '/widgets/:id' do
#   widget = Widget.find(params[:id])
#   return status 404 if widget.nil?
#   widget.update(params[:widget])
#   widget.save
#   status 202
# end
#
# delete '/widgets/:id' do
#   widget = Widget.find(params[:id])
#   return status 404 if widget.nil?
#   widget.delete
#   status 202
# end
