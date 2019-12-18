class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index create]
  before_action :find_answer, only: %i[show destroy update]
  after_action :publish_answer, only: %i[create]
  authorize_resource class: Answer

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      head :ok
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

  def publish_answer
    return if @answer.errors.any?

    files = @answer.files.map do |file|
      { id: file.id, url: url_for(file), name: file.filename.to_s }
    end

    links = @answer.links.map do |link|
      { id: link.id, name: link.name, url: link.url, gist: (link.url if link.gist?) }
    end

    ActionCable.server.broadcast(
        "answers-#{@answer.question_id}", { answer: @answer, links: links, files: files }
    )
  end
end
