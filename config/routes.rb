Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }

resources :users, only: [:index, :show] do
    member do
      get 'send_request', to: 'friendships#create'
      get 'accept_request', to: 'friendships#update'
      delete 'reject_request', to: 'friendships#destroy'
      get 'all_friends', to: 'friends#all_friends'
      get 'show_friend/:friend_id', to: 'friends#show_friend', as: 'show_friend'
    end
  end
  resources :posts do
  member do
    get 'like'
    get 'unlike'
  end
  end

  resources :comments do
    post 'reply', on: :member, to: 'comments#create_reply'
  end

  # Route for showing the profile
  get 'profile', to: 'profiles#show', as: 'profile'

  # Route for updating the profile
  patch 'profile', to: 'profiles#update'

  resource :profile, only: [:show] do
    member do
      patch :update_cover_photo
      patch :update_profile_photo
    end
  end


  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'sign_up', to: 'devise/registrations#new'
    delete 'sign_out', to: 'devise/sessions#destroy'
    root to: 'feeds#index'
  end

  get 'feed', to: 'feeds#index', as: 'feed'

  get 'add_friends', to: 'friends#add_friends'

  # get 'remove_friends', to: 'friends#remove_friends'

end
