class Search::SearchController < ApplicationController
  skip_authorization_check
  def get_search; end

  def proceed
    search_result = Services::Finding.new.call(search_params)
    render json: array_of_serialized(search_result).to_json
  end

  private

  def search_params
    params.permit(:finding, :question_flag, :answer_flag, :comment_flag, :user_flag)
  end

  def array_of_serialized(array_of_models)
    array_of_models.map { |item| ActiveModelSerializers::SerializableResource.new(item).as_json }
  end
end

