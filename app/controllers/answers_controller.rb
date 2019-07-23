class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[show destroy update star unstar]

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
    @question = @answer.question
    @prev_ranked = @question.answers.ranked.first

    unless @prev_ranked.nil?
      @prev_ranked.ranked = false
      @prev_ranked.save
    end

    @answer.ranked = true
    @answer.save
    render :star
  end

  def unstar
    @answer.ranked = false
    @answer.save
    render :unstar
  end

  def update
    @answer.update(answer_params) if current_user&.author?(@answer)
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit( :body, :ranked)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
