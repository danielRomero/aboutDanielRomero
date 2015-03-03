class GoogleController < ApplicationController

  def authenticate
    require 'oauth2'
    client = OAuth2::Client.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], :site => 'https://accounts.google.com/o/oauth2/auth', :authorize_url => "/o/oauth2/auth", :token_url => "/o/oauth2/token")
    callback_url = authenticate_google_url(I18n.locale)
    # https://accounts.google.com/o/oauth2/auth
    if params[:code].nil?
      redirect_to client.auth_code.authorize_url(:redirect_uri => callback_url, :scope => 'https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email', :access_type => "offline", :approval_prompt => 'force')
      # => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"
    else
      token = client.auth_code.get_token(params[:code], :redirect_uri => callback_url)

      response = token.get('https://www.googleapis.com/oauth2/v1/userinfo?alt=json')
      response.class.name
      # => OAuth2::Response
      logger.debug "\n\n\n#{response.inspect}\n\n\n"
      redirect_to contact_path(I18n.locale)
    end
  end

end
