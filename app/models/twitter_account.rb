class TwitterAccount < ActiveRecord::Base
  has_many :tweets

  # Retrieve all twitter account data of user from tweeter API
  def update_all_account_data
    tw_user = twitter_connection.user

    self.followers_count = tw_user.followers_count
    self.following_count = tw_user.friends_count
    self.tweets_count    = tw_user.tweets_count
    self.avatar_url      = "#{tw_user.profile_image_url.scheme}://#{tw_user.profile_image_url.host}#{tw_user.profile_image_url.path.gsub('normal', '400x400')}"
    self.username        = "@#{twitter_connection.user.screen_name}"
    self.url             = "#{tw_user.url.scheme}://#{tw_user.url.host}#{tw_user.url.path}"
    self.save
    self.fetch_latest_tweets(self.tweets.count > 0  ? self.tweets.order(tweet_created_at: :desc).first.twitter_id : nil) if tw_user.tweets_count > self.tweets.count
  end

  # Retrieve news tweets from twitter or update olds
  def fetch_latest_tweets(last_id = self.tweets ? self.tweets.order(tweet_created_at: :desc).first.twitter_id : nil)
    options = { count: 4, include_rts: true }
    options[:max_id] = last_id if last_id
    begin
      response = twitter_connection.user_timeline(options)
      response.each do |tw_tweet|
        tweet = Tweet.find_or_initialize_by(twitter_id: tw_tweet.id)
        tweet.retweet_count      = tw_tweet.retweet_count
        tweet.favorite_count     = tw_tweet.favorite_count
        tweet.tweet_created_at   = tw_tweet.created_at
        tweet.url                = tw_tweet.url.to_s
        tweet.full_text          = tw_tweet.full_text
        tweet.twitter_account_id = self.id
        tweet.save
      end
      fetch_latest_tweets( response.last.id - 1 ) if response.last
    rescue => e
      ExceptionNotifier.notify_exception(e)
      raise e.exception if Rails.env.development?
    end
    return true
  end
  
  private
    def twitter_connection
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TW_CONSUMER_KEY']
        config.consumer_secret     = ENV['TW_CONSUMER_SECRET']
        config.access_token        = ENV['TW_ACCESS_TOKEN']
        config.access_token_secret = ENV['TW_ACCESS_TOKEN_SECRET']
      end
    end
end
