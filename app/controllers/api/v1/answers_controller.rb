class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer
  before_action :find_question, only: :index
  before_action :find_answer, only: :show

  def index
    @answers = @question.answers.all
    render json: @answers
  end

  def show
    render json: @answer
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
