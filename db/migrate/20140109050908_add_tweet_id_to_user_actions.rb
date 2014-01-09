class AddTweetIdToUserActions < ActiveRecord::Migration
  def change
    add_column :user_actions, :tweet_id, :int8
  end
end
