class FacebookController < ApplicationController

  def authenticate
    if params[:id] and params[:email] and params[:first_name] and params[:picture]
      begin
        user = {
          avatar: params[:picture][:data][:url],
          name: params[:first_name] + params[:last_name],
          email: params[:email]
        }
        reset_session
        session[:user] = user
        render template: 'application/contact', locals: { user: user }
      rescue
        redirect_to request.referer
      end
    else
      redirect_to request.referer
    end
  end

end