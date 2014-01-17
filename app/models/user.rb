class User < ActiveRecord::Base
  has_many :user_actions

  def most_recent_actions
    # TODO evaluate performance of doing this as a subselect, table join instead of ruby
    user_tweets = user_actions.order(:created_at).reverse_order
    user_tweets.inject({}) do |action_tweets, tweet|
      action_tweets[tweet.action] ||= tweet
      action_tweets
    end.values
  end
end
