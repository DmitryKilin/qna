class Search::SearchController < ApplicationController
  skip_authorization_check
  def get_search
  end

  def proceed
    @question_entries = ['Вопрос 1', 'Вопрос 2', 'Вопрос 3']
    @answer_entries = ['Ответ 1', 'Ответ 2', 'Ответ 3']
    @comment_entries = ['Комментарий 1', 'Комментарий 2', 'Комментарий 3']
    @user_entries = ['Пользователь 1', 'Пользователь 2', 'Пользователь 3']

  end
end
