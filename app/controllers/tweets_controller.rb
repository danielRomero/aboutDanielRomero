class TweetsController < ApplicationController
  
  include TweetsHelper

  def index
    page = (params[:page].blank? or params[:page].to_i < 0) ? 0 : params[:page].to_i
    render locals: {tweets: get_tweets(page), page: page }
  end
end
