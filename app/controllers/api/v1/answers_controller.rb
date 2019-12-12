class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource class: Answer
  before_action :find_answer, only: :show

  def show
    render json: @answer, serializer: AnswerWithAddonsSerializer
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
