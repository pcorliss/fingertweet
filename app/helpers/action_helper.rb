module ActionHelper
  def action_icons(action)
    action_icon_map = AppConfig.actions.icons
    action_icon_map[action.to_sym] || action_icon_map[:unknown]
  end
end
