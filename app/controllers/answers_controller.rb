class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[show destroy update star unstar]

  after_action :publish_answer, only: %i[create]

  authorize_resource
  include Voted

  def destroy
    @answer.delete if current_user.author?(@answer)
  end

  def create
    @answer = @question.answers.new answer_params
    @answer.user = current_user
    @answer.save
  end

  def show; end

  def star
    @answer.rank
  end

  def unstar
    @answer.unrank
  end

  def update
    @answer.update(answer_params) if current_user&.author?(@answer)
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :ranked, files: [], links_attributes: %i[name url id _destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    files = @answer.files.map do |file|
      { id: file.id, url: url_for(file), name: file.filename.to_s }
    end

    links = @answer.links.map do |link|
      { id: link.id, name: link.name, url: link.url, gist: (link.gist(link.url) if link.gist?) }
    end

    ActionCable.server.broadcast(
      "answers-#{@answer.question_id}", answer: @answer, links: links, files: files
    )
  end
end
