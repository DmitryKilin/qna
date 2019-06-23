class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: %i[new create]

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def new
    @answer = Answer.new
  end

  private

  def answer_params
    params.require(:answer).permit( :body, :question_id )
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
