FingerTweet::Application.routes.draw do
  # Note: This satisifies the root path
  # TODO Handle resources like favicon and apple touch icon, etc..
  resources :user_actions, path: '', only: [:show, :index] do
    collection do
      post :reindex
    end
  end
end
