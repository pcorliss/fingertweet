FingerTweet::Application.routes.draw do
  #root 'home#index'
  resources :user_actions, path: '', only: [:show]
end
