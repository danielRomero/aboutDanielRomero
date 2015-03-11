class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale

  def clear_session
    reset_session
    flash[:notice] = t(:session_logged_out)
    redirect_to root_path(I18n.locale)
  end

  def change_locale
    #raise request.inspect
    redir = []
    request.referer.split('/').each do |a|
      a = I18n.locale if LOCALES.include?(a)
      redir << a
    end
    redirect_to "#{redir.join('/')}?locale=#{I18n.locale}"
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
