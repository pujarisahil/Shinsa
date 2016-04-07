#!/usr/bin/ruby -w

require "koala"
require_relative "access_account"

def index
	unless current_user.facebook_oauth_setting
		@oauth = Koala::Facebook::OAuth.new("app_id", "app_secret", "http://#{request.host}:#{request.port}/callback")
		session["oauth_obj"] = @oauth
		redirect_to @oauth.url_for_oauth_code
	else
		redirect_to "/facebook_profile"
	end
end

def facebook_profile
	if current_user.facebook_oauth_setting
		@graph = Koala::Facebook::API.new(current_user.facebook_oauth_setting.access_token)
		#get name, id, and link
		@profile = @graph.get_object("me")
		#get picture
		@picture = @graph.get_picture("me")
		return @profile @picture
	else
		redirect_to "/"
	end
end
