desc "This task is called by the Heroku scheduler add-on every day at 5:00 UTC"
task :update_twitter_data => :environment do
  puts "Updating twitter data..."
  include ApplicationHelper
  include TweetsHelper
  puts "Clearing cache..."
  Rails.cache.clear
  puts "Getting all Tweets"
  get_all_tweets
  sleep(5)
  puts "Getting tweets count"
  tweets_count
  sleep(5)
  puts "Getting followers count"
  followers_count
  sleep(5)
  puts "Getting following count"
  following_count
  puts "done."
end