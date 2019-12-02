class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  after_action :publish_question, only: %i[create]

  include Voted

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.build
    @question.build_prize
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    redirect_to @question, notice: 'Your question successfully created' if @question.save
  end

  def destroy
    if current_user.author?(@question)
      @question.delete
      note = 'Question have been deleted!'
    else
      note = 'You can delete yours questions only!'
    end
    redirect_to questions_path, notice: note
  end

  def update
    @question.update(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url id _destroy], prize_attributes: %i[praise reward])
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
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
