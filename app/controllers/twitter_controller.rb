class TwitterController < ApplicationController

  def authenticate
    @consumer = OAuth::Consumer.new( ENV['TW_CONSUMER_KEY'], ENV['TW_CONSUMER_SECRET'], {
    :site               => "https://api.twitter.com",
    :scheme             => :header,
    :http_method        => :post,
    :request_token_path => "/oauth/request_token",
    :access_token_path  => "/oauth/access_token",
    :authorize_path     => "/oauth/authenticate"
    })
    
    if params["oauth_token"].nil?
      # pido permisos
      callback_url = authenticate_twitter_url
      
      request_token = @consumer.get_request_token(:oauth_callback => callback_url)
      session[:request_token] = request_token
      redirect_to request_token.authorize_url(:oauth_callback => callback_url)

    else
      # pido los datos
      request_token = OAuth::RequestToken.new(@consumer, session[:request_token]['token'], session[:request_token]['secret'])
      begin
        access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
        tw_user_request = access_token.get('https://api.twitter.com/1.1/account/verify_credentials.json')
        
        tw_user = JSON.parse(tw_user_request.body).to_hash.symbolize_keys
        if tw_user[:name]
          user = {
            avatar: tw_user[:profile_image_url].slice!('_normal'),
            name: tw_user[:name],
            location: tw_user[:location],
            link: "https://twitter.com/#{tw_user[:screen_name]}",
            email: tw_user[:email]
          }
          session[:user] = user
          render template: 'application/contact', locals: { user: user }
        else
          redirect_to contact_path
        end
      rescue
        redirect_to contact_path
      end
    end
  end

end
