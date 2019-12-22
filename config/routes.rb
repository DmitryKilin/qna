require 'sidekiq/web'
Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'profiles/me'
  use_doorkeeper
  devise_for :users, controllers: {
      omniauth_callbacks: 'oauth_callbacks',
      confirmations: 'oauth_confirmations'
  }

  root to: 'questions#index'

  devise_scope :user do
    get :demand_email, to: 'oauth_confirmations#demand_email'
    get :send_confirmation, to: 'oauth_confirmations#send_confirmation'
  end

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :files, only: :destroy, as: 'delete_file'
  resources :links, only: :destroy, as: 'delete_link'

  resources :users, only: [] do
    get :rewards, on: :member
  end

  resources :questions, concerns: :votable do
    resources :subscriptions, shallow: true, only: %i[create destroy]
    resource :comments, only: %i[create]
    resources :answers, only: %i[destroy create show update], shallow: true, concerns: :votable  do
      resource :comments, only: %i[create]
      member do
        patch :star
        patch :unstar
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'

end
