Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'

  # aishek 7 hours ago
  # Не к вопросам, а к ответам. Цель в том, чтобы передавать в роут-хелперы
  # не вопрос и ответ (как происходит в случае вложенных роутов),
  # а один — только вопрос https://guides.rubyonrails.org/routing.html#shallow-nesting
  resources :questions, shallow: true do
    resources :answers, only: %i[ destroy create show]
  end
#  You can also specify the :shallow option in the *PARENT* resource,
#  in which case all of *THE NESTED RESOURCES WILL BE SHALLOW*:
#
# resources :articles, shallow: true do
#   resources :comments
#   resources :quotes
#   resources :drafts
# end

end
