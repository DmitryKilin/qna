class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[show destroy]

  def destroy
    question = @answer.question
    if author?
      @answer.delete
      note = "Answer have been deleted!"
    else
      note = "You can delete yours answers only!"
    end
    redirect_to question_path(question), notice:  note
  end

  def create
    puts 'PARAMS: ' + answer_params.inspect
    if answer_params[:body].match?(/\w+/)
      @answer = @question.answers.new(answer_params)
      @answer.user_id = current_user.id
      @answer.save
      flash.notice = 'Answer was added!'
    else
      flash.alert = "Answer can't be blank!"
    end
    redirect_to @question
  end

  def show

  end

  private

  def answer_params
    params.require(:answer).permit( :body, :user_id)
  end

  def author?
    @answer.user == current_user
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
