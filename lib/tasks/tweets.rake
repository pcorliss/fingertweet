namespace :tweets do
  desc "Periodic import of tweet mentions"
  task :import => :environment do
    start = Time.now
    last_user = User.last

    new_actions = UserAction.create_recent_user_actions.compact

    new_user_count = User.where('id > ?', last_user).count
    duration = Time.now - start
    Rails.logger.info "RAKE::Tweet:Import::Added #{new_actions.count} tweets and #{new_user_count} users in #{duration} seconds"
  end
end
