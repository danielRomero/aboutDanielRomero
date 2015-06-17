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

desc "This task is called by the Heroku scheduler add-on every day at 5:00 UTC"
task :wake_up => :environment do
  # Apago el servidor a las 6 AM, luego lo levanto
  heroku = Heroku::API.new(api_key: ENV['HEROKU_API_KEY'])
  app = 'danielromero'
  processes = heroku.get_ps(app).body.length

  if [5,6].include?(Time.now.hour)
    heroku.post_ps_scale(app, 'web', 0) if processes > 0
  else
    heroku.post_ps_scale(app, 'web', 1) if processes == 0
    require 'unirest'
    Unirest.get "http://danielromero.herokuapp.com/"
  end
end