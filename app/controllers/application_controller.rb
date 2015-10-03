class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale, except: [:sitemap]

  def index
    if params[:token]
      session[:track_token] = Base64.decode64 params[:token]
    else
      session.delete(:track_token)
    end
    @twitter_account = TwitterAccount.first
  end

  def clear_session
    reset_session
    flash[:notice] = t(:session_logged_out)
    redirect_to root_locale_path(I18n.locale)
  end

  private
    def set_locale
      if params[:locale].blank?
        # locale from browser
        locale = request.env['HTTP_ACCEPT_LANGUAGE'].blank? ? I18n.default_locale : request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
        I18n.locale = locale if LOCALES.include?(locale)
      elsif LOCALES.include?(params[:locale])
        # locale from params
        I18n.locale = params[:locale] || I18n.default_locale
      end
    end
end
