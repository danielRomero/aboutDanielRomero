class TweetsController < ApplicationController

  def index
    @page = (params[:page].blank? or params[:page].to_i < 0) ? 0 : params[:page].to_i
  end
end
