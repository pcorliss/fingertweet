module ActionHelper
  def action_icons(action)
    action_icon_map = AppConfig.actions.icons
    action_icon_map[action.to_sym] || action_icon_map[:unknown]
  end

  def embed_links(text)
    linked_text = text.gsub(/http:\/\/[^\s]+/) do |url|
      link_to(url, url, :rel => 'nofollow')
    end
    linked_text.gsub(/@[^\s]+/) do |handle|
      twitter_linker(handle.delete('@'))
    end
  end

  def strip_twitter_to(text)
    tweet_to = '@FingerTweeter'
    text.gsub(/#{tweet_to}\s+/, '').gsub(/\s+#{tweet_to}/, '')
  end

  def sanitize_content(text)
    embed_links(strip_twitter_to(text))
  end

  def twitter_linker(twitter_handle)
    if current_page?(user_action_path(:id => twitter_handle)) || !User.exists?(:twitter_user => twitter_handle)
      return link_to '@' + twitter_handle, "https://twitter.com/#{twitter_handle}"
    end
    link_to '@' + twitter_handle, user_action_path(:id => twitter_handle)
  end
end
