class Search::SearchController < ApplicationController
  skip_authorization_check
  def get_search; end

  def proceed
    @search_result = Services::Finding.new.call(search_params)
    if @search_result.nil?
      xhr = nil
    else
      xhr = @search_result.empty? ? nil : array_of_serialized(@search_result)
    end
    respond_to do |format|
      format.json { render json: xhr }
    end
  end

  private

  def search_params
    params.permit(:finding, :question_flag, :answer_flag, :comment_flag, :user_flag)
  end

  def array_of_serialized(array_of_models)
    array_of_models.map { |item| ActiveModelSerializers::SerializableResource.new(item).as_json }
  end
end

# TO_DO

# В search.js написпть код вывода результата поиска в соответствующих div-ах:
# {"user":{"id":"!USER SERIALIZER!"} в .user_entries;
# {"answer":{"id":"!ANSWER SERIALIZER!"}} в .answer_entries
# и т.д.
