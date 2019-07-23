Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, only: %i[ destroy create show update], shallow: true do
      member do
        patch :star
        patch :unstar
      end
    end
  end

end
