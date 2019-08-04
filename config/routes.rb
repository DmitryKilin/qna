Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  resources :files, only: :destroy, as: 'delete_file'
  resources :links, only: :destroy, as: 'delete_link'

  resources :users, only: [] do
    get :rewards, on: :member
  end

  resources :questions do
    resources :answers, only: %i[ destroy create show update], shallow: true do
      member do
        patch :star
        patch :unstar
      end
    end
  end

end
