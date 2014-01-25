class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_last_index

  def set_last_index
    @last_index = Rails.cache.read('last_tweet_index')
  end
end
