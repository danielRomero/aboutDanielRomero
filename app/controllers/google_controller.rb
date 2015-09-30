class GoogleController < ApplicationController

  def authenticate
    require 'oauth2'
    client = OAuth2::Client.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], :site => 'https://accounts.google.com/o/oauth2/auth', :authorize_url => "/o/oauth2/auth", :token_url => "/o/oauth2/token")
    callback_url = authenticate_google_url
    if params[:code].nil?
      redirect_to client.auth_code.authorize_url(:redirect_uri => callback_url, :scope => 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email', :access_type => "offline", :approval_prompt => 'force')
    else
      token = client.auth_code.get_token(params[:code], :redirect_uri => callback_url)

      response = token.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json')

      begin
        response = response.parsed.symbolize_keys
        if(response[:id] and response[:name])
          user = {
            avatar: response[:picture],
            name: response[:name],
            email: response[:email],
            id: response[:id],
            social: 'google'
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
      redirect_to contact_path(I18n.locale)
    end
  end

end
