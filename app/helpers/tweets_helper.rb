module TweetsHelper
  def following_count
    key = ['v1', 'following_count'].join('/')
    if (following_count = cache_read(key)).nil?
      following_count = cache_write(key, twitter_connection.user.friends_count)
    end
    return following_count
  end
  
  def followers_count
    key = ['v1', 'followers_count'].join('/')
    if (followers_count = cache_read(key)).nil?
      followers_count = cache_write(key, twitter_connection.user.followers_count)
    end
    return followers_count
  end
  
  def tweets_count
    key = ['v1', 'tweets_count'].join('/')
    if (tweets_count_cache = cache_read(key)).nil?
      tweets_count_cache = cache_write(key, twitter_connection.user.tweets_count)
    end
    return tweets_count_cache
  end
  
  def get_tweets(page=0)
    cache_read(['v1', page, 'tweets_page'].join('/'))
  end

  def get_all_tweets
    page = -1
    collect_with_max_id do |max_id|
      options = {count: 4, include_rts: true}
      options[:max_id] = max_id unless max_id.nil?
      page += 1
      key = ['v1', page, 'tweets_page'].join('/')
      if (tweets_page = cache_read(key)).nil?
        tweets_page = cache_write(key, twitter_connection.user_timeline(options))
      end
      tweets_page
    end
  end

  

  private

    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield(max_id)
      collection += response
      response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
    end

    def twitter_connection
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TW_CONSUMER_KEY']
        config.consumer_secret     = ENV['TW_CONSUMER_SECRET']
        config.access_token        = ENV['TW_ACCESS_TOKEN']
        config.access_token_secret = ENV['TW_ACCESS_TOKEN_SECRET']
      end
    end
end
