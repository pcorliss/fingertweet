FactoryGirl.define do
  factory :user_action do
    twitter_user 'pcorliss_fake'
    action 'read'
    content "I'm reading A Tale of Two Cities."
    past_tense false
  end
end
