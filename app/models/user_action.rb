class UserAction < ActiveRecord::Base
  belongs_to :user

  class << self
    def create_recent_user_actions
      last_tweet_id_captured = maximum(:tweet_id) || 0
      mentions = twitter_client.mentions.map do |tweet|
        if tweet.id > last_tweet_id_captured
          # TODO we can cache this lookup and make this a bit more performant
          user = User.find_or_create_by(twitter_user: tweet.user.screen_name)
          user.update_attributes(avatar_uri: tweet.user.profile_image_uri.to_s)
          user.user_actions.create(
            content: tweet.text,
            past_tense: false, # TODO this seemed necessary initially, might want to remove it.
            action: discover_action(tweet.text),
            tweet_id: tweet.id,
            created_at: tweet.created_at
          )
        end
      end.compact
      Rails.cache.write('last_tweet_index', Time.now, :expires_in => 30.days)
      mentions
    end

    def discover_action(text)
      AppConfig.actions.tenses.each do |action, action_tenses|
        action_tenses.each do |tense|
          return action if text.include?("\s#{tense}\s")
        end
      end
      'unknown'
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
