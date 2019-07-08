class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[new create]
  before_action :find_answer, only: %i[show destroy]

  def destroy
    question = @answer.question
    if current_user.author?(@answer)
      @answer.delete
      note = "Answer have been deleted!"
    else
      note = "You can delete yours answers only!"
    end
    redirect_to question_path(question), notice:  note
  end

  def create
    @answer = @question.answers.create answer_params
    @answer.user = current_user

    if @answer.save
      redirect_to @answer.question, notice: "Answer was saved"

    end
  end

  def show; end

  private

  def answer_params
    params.require(:answer).permit( :body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
