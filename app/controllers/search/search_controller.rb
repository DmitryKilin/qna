class Search::SearchController < ApplicationController
  skip_authorization_check
  def get_search; end

  def proceed
    @search_result = Services::Finding.new.call(search_params)
    xhr = @search_result.empty? ? nil : array_of_serialized(@search_result)
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
#
#  реализовать подстаноовку соответствующего пути к ресурсу во вьюхе show для comments_controller стр. 4
#  используя методы контроллера для поиска ресурса. Написать спеки.
#
#  написать спеки для метода delete для comments_controller, реализовать удаление комметария автором.
# 
# В search.js написпть код вывода результата поиска в соответствующих div-ах:
# {"user":{"id":"!USER SERIALIZER!"} в .user_entries;
# {"answer":{"id":"!ANSWER SERIALIZER!"}} в .answer_entries
# и т.д.
