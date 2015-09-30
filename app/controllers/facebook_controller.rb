class FacebookController < ApplicationController

  def authenticate
    if params[:id] and params[:email] and params[:first_name] and params[:avatar]
      begin
        user = {
          avatar: params[:avatar],
          name: params[:first_name] + params[:last_name],
          email: params[:email],
          id: params[:id],
          social: 'facebook'
        }
        reset_session
        session[:user] = user
        flash[:success] = t(:user_logged_in)
      rescue Exception => e
        ExceptionNotifier.notify_exception(e)
        flash[:error] = t(:social_login_error)
      end
    else
      flash[:error] = t(:social_login_error)
    end
    redirect_to contact_path(I18n.locale)
  end

end