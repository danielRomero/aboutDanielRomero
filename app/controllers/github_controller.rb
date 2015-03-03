class GithubController < ApplicationController

  def authenticate
    require 'oauth2'
    client = OAuth2::Client.new(ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], :site => 'https://github.com', :authorize_url => "/login/oauth/authorize", :token_url => "/login/oauth/access_token")
    callback_url = authenticate_github_url(I18n.locale)
    # https://accounts.google.com/o/oauth2/auth
    if params[:code].nil?
      redirect_to client.auth_code.authorize_url(:redirect_uri => callback_url, :scope => 'user')
      # => "https://example.org/oauth/authorization?response_type=code&client_id=client_id&redirect_uri=http://localhost:8080/oauth2/callback"
    else
      token = client.auth_code.get_token(params[:code], :redirect_uri => callback_url)

      response = token.get('https://api.github.com/user')
      response.class.name
      # => OAuth2::Response
      logger.debug "\n\n\n#{response.inspect}\n\n\n"
      redirect_to contact_path(I18n.locale)
    end
  end

end