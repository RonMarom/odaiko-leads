class SessionsController < ApplicationController
  
  def create
  	auth = request.env["omniauth.auth"]
    credentials = auth['credentials']
    token = credentials['token']
    secret = credentials['secret']

  	social_login= SocialAccount.new
  	social_login.token=token
  	social_login.secret=secret
  	social_login.save

  	redirect_to root_path
  end

  def failure
  end
end
