class UserAction < ActiveRecord::Base
  class << self
    def create_recent_user_actions
      twitter_client.search("to:FingerTweeter", result_type: "recent", since_id: maximum(:tweet_id)).map do |tweet|
        create(
          twitter_user: tweet.user.screen_name,
          content: tweet.text,
          past_tense: false,
          action: nil,
          tweet_id: tweet.id
        )
      end
    end

    def discover_action(text)
      AppConfig.actions.each do |action, action_tenses|
        action_tenses.each do |tense|
          return action if text.include?(tense)
        end
      end
      nil
    end

    private

    def twitter_client
      # TODO It would be nice if we could just pass the config hash in somehow.
      # Need to take a peek at the code and see if we can
      Twitter::REST::Client.new do |config|
        config.consumer_key         = AppConfig.twitter.consumer_key
        config.consumer_secret      = AppConfig.twitter.consumer_secret
        config.access_token         = AppConfig.twitter.access_token
        config.access_token_secret  = AppConfig.twitter.access_token_secret
      end
    end
  end
end
