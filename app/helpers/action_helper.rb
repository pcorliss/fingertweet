module ActionHelper
  def action_icons(action)
    action_icon_map = AppConfig.actions.icons
    action_icon_map[action.to_sym] || action_icon_map[:unknown]
  end

  def embed_links(text)
    text.gsub(/(http:\/\/[^\s]+)/, link_to('\1', '\1', :rel => 'nofollow'))
  end

  def strip_twitter_to(text)
    tweet_to = '@FingerTweeter'
    text.gsub(/#{tweet_to}\s+/, '').gsub(/\s+#{tweet_to}/, '')
  end

  def sanitize_content(text)
    embed_links(strip_twitter_to(text))
  end
end
