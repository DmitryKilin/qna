class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer
  before_action :find_question, only: %i[index create]
  before_action :find_answer, only: %i[show destroy update]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @answer
    if @answer.destroy
      render json: {}, status: :ok
    else
      render json: { errors: @answer.errors }, status: 418
    end
  end

  def index
    @answers = @question.answers.all
    render json: @answers
  end

  def show
    render json: @answer
  end

  def update
    authorize! :update, @answer
    if @answer.update(answer_params)
      render json: @answer
    else
      render json: { errors: @answer.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :ranked, files: [], links_attributes: %i[name url id _destroy])
  end
end
