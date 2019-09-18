Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  # concern :commentable do
    # resources :comments, only: %i[create], as: 'comment_out'
  #   post :comment, on: :member
  # end
  concern :commentable do
    resource :comments, only: %i[create]
  end

  resources :files, only: :destroy, as: 'delete_file'
  resources :links, only: :destroy, as: 'delete_link'

  resources :users, only: [] do
    get :rewards, on: :member
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, only: %i[ destroy create show update], shallow: true, concerns: [:votable, :commentable]  do
      member do
        patch :star
        patch :unstar
      end
    end
  end

  mount ActionCable.server => '/cable'

end
