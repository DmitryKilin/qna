class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question
  before_action :find_question, only: %i[show show_answers]

  def create
    authorize! :create, Question
    @question = current_user.questions.new(question_params)
    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

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

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:name, :url, :id, :_destroy])
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
