class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[new create]

  def create
    unless answer_params[:body].match?(/\S*/)
      @answer = @question.answers.new(answer_params)
      @answer.save
      flash.notice = 'Answer was added!'
    else
      flash.alert = "Answer can't be blank!"
    end
    redirect_to @question
  end

  private

  def answer_params
    params.require(:answer).permit( :body, :user_id )
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
