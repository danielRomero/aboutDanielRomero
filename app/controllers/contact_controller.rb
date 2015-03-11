class ContactController < ApplicationController
  
  def send_message
    if params[:message] and session[:user] and (params[:email] or session[:user][:email])
      email = params[:email] || session[:user][:email]
      if validate_email(email)
        MessageMailer.contact_message(session[:user], email, params[:message]).deliver_now
        session[:message] = nil
        flash[:success] = t(:message_sent)
      else
        session[:message] = params[:message]
        flash[:warning] = t(:not_valid_email)
      end
    else
      session[:message] = params[:message]
      flash[:error] = t(:not_valid_params)
    end
    redirect_to contact_path(I18n.locale)
  end

  private

    def validate_email(email)
      regexp = /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/
      return regexp.match(email)
    end

end