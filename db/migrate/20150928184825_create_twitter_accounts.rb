class CreateTwitterAccounts < ActiveRecord::Migration
  def change
    create_table :twitter_accounts do |t|
      t.string :username, default: ''
      t.integer :followers_count, default: 0
      t.integer :following_count, default: 0
      t.string :url, default: ''
      t.string :avatar_url, default: ''
      t.integer :tweets_count, default: 0

      t.timestamps null: false
    end
  end
end