class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :retweet_count, default: 0
      t.integer :favorite_count, default: 0
      t.datetime :tweet_created_at
      t.string :url
      t.text :full_text, default: ''
      t.integer :twitter_account_id
      t.string :twitter_id
      
      t.index :twitter_account_id

      t.timestamps null: false
    end
  end
end