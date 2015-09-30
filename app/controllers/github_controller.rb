class GithubController < ApplicationController

  def authenticate
    require 'oauth2'
    client = OAuth2::Client.new(ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], :site => 'https://github.com', :authorize_url => "/login/oauth/authorize", :token_url => "/login/oauth/access_token")
    callback_url = authenticate_github_url
    if params[:code].nil?
      redirect_to client.auth_code.authorize_url(:redirect_uri => callback_url, :scope => 'user,user:email')
    else
      token = client.auth_code.get_token(params[:code], :redirect_uri => callback_url)

      response = token.get('https://api.github.com/user')

      begin
        response = response.parsed.symbolize_keys
        
        if response[:id] and response[:name]
          user = {
            avatar: response[:avatar_url],
            name: response[:name],
            location: response[:location],
            email: response[:email],
            id: response[:id],
            social: 'github'
          }
          reset_session
          session[:user] = user
          flash[:success] = t(:user_logged_in)
        else
          flash[:error] = t(:social_login_error)
        end
      rescue Exception => e
        ExceptionNotifier.notify_exception(e)
        flash[:error] = t(:social_login_error)
      end
      redirect_to contact_path
    end
  end

end