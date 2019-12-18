class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: %i[show show_answers update destroy]
  after_action :publish_question, only: %i[create]
  authorize_resource class: Question

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @question
    if @question.destroy
      head :ok
    else
      render json: { errors: @question.errors }, status: 418
    end
  end

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: @question
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question
    else
      render json: { errors: @question.errors }, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url id _destroy])
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
            partial: 'questions/question',
            locals: { question: @question }
        )
    )
  end
end
