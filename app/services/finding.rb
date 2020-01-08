class Services::Finding
  PROPER_SCOPES = %w[Question Answer Comment User]
  def call(search_params)
    scope = search_params.values & PROPER_SCOPES
    return if search_params[:finding].blank? || scope.empty?
    
    ThinkingSphinx.search search_params[:finding], classes: scope.map { |item| item.classify.constantize }
  end
end
