class UserAction < ActiveRecord::Base
  class << self
    def create_recent_user_actions
      # TODO It would be nice if we could just pass the config hash in somehow.
      # Need to take a peek at the code and see if we can
      client = Twitter::REST::Client.new do |config|
        config.consumer_key         = AppConfig.twitter.consumer_key
        config.consumer_secret      = AppConfig.twitter.consumer_secret
        config.access_token         = AppConfig.twitter.access_token
        config.access_token_secret  = AppConfig.twitter.access_token_secret
      end
      client.search("to:FingerTweeter", result_type: "recent", since_id: maximum(:tweet_id)).map do |tweet|
        create(
          twitter_user: tweet.user.screen_name,
          content: tweet.text,
          past_tense: false,
          action: nil,
          tweet_id: tweet.id
        )
      end
    end
  end
end
