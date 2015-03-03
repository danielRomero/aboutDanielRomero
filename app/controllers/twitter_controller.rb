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
      callback_url = authenticate_twitter_url(I18n.locale)
      
      request_token = @consumer.get_request_token(:oauth_callback => callback_url)
      session[:request_token] = request_token
      redirect_to request_token.authorize_url(:oauth_callback => callback_url)

    else
      # pido los datos
      request_token = OAuth::RequestToken.new(@consumer, session[:request_token]['token'], session[:request_token]['secret'])

      access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
      tw_user_request = access_token.get('https://api.twitter.com/1.1/account/verify_credentials.json')
      
      tw_user = JSON.parse(tw_user_request.body).to_hash
      logger.debug "#{tw_user.inspect}"
      # TW nos devuelve una imagen pequeña, quitando "_normal" de la url obtenemos la original (ojo, NO es una chapuza, así lo pone en la doc de tw)
      image_url = tw_user['profile_image_url'].slice! '_normal'
      social_link = 'https://twitter.com/'+tw_user['screen_name'].to_s
      name = tw_user['name']
      avatar = tw_user['profile_image_url']
      location = tw_user['location']
      twitter_id = tw_user['id_str']
      
      logger.debug "\n\n\n#{image_url} - #{social_link} - #{name} - #{avatar} - #{location} - #{twitter_id}\n\n\n"

      redirect_to contact_path(I18n.locale), flash: { notice: "#{image_url} - #{social_link} - #{name} - #{avatar} - #{location} - #{twitter_id}" }
    end
  end

end
