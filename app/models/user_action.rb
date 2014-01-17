class UserAction < ActiveRecord::Base
  class << self
    def create_recent_user_actions
      last_tweet_id_captured = maximum(:tweet_id) || 0
      twitter_client.mentions.map do |tweet|
        if tweet.id > last_tweet_id_captured
          create(
            twitter_user: tweet.user.screen_name,
            content: tweet.text,
            past_tense: false, # TODO this seemed necessary initially, might want to remove it.
            action: discover_action(tweet.text),
            tweet_id: tweet.id,
            created_at: tweet.created_at
          )
        end
      end
    end

    def discover_action(text)
      AppConfig.actions.tenses.each do |action, action_tenses|
        action_tenses.each do |tense|
          return action if text.include?(tense)
        end
      end
      nil
    end

    # TODO strip @TwitterFinger out and for presentation

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
