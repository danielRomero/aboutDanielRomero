class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def index
    if params[:token]
      session[:track_token] = Base64.decode64 params[:token]
    else
      session.delete(:track_token)
    end
  end

  def clear_session
    reset_session
    flash[:notice] = t(:session_logged_out)
    redirect_to root_locale_path(I18n.locale)
  end

  def change_locale
    if request.referer
      redir = []
      request.referer.split('/').each do |a|
        a = I18n.locale if LOCALES.include?(a)
        redir << a
      end
      redirect_to "#{redir.join('/')}?locale=#{I18n.locale}"
    else
      redirect_to root_locale_path(I18n.locale)
    end
  end

  private
    def set_locale
      if params[:locale].blank?
        # locale from browser
        logger.debug "[LOCALE] Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']} - Params: #{params[:locale]}"
        I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].blank? ? I18n.default_locale : request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
      elsif LOCALES.include?(params[:locale])
        # locale from params
        I18n.locale = params[:locale] || I18n.default_locale
      end
      logger.debug "[LOCALE] Locale set to '#{I18n.locale}'"
    end
end
