class Tweet < ActiveRecord::Base
  belongs_to :twitter_account, touch: true
  validates_presence_of [:full_text, :twitter_id, :url, :twitter_account_id]
  validates_uniqueness_of :twitter_id
  PER_PAGE=4
end
