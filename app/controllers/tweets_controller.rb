class TweetsController < ApplicationController

  def index
    @page = (params[:page].blank? or params[:page].to_i < 0) ? 0 : params[:page].to_i
    respond_to do |format|
      format.js { render }
      format.html { redirect_to root_locale_path(I18n.locale) }
    end
  end
end
