FactoryGirl.define do
  factory :user_action do
    #user
    action 'read'
    content "I'm reading A Tale of Two Cities."
    past_tense false
  end
end
