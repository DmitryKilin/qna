class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question
  before_action :find_question, only: %i[show show_answers]

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def show_answers
    @answers = @question&.answers
    render json: @answers
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end
end
