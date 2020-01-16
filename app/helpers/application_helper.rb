module ApplicationHelper
  def cache_index_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    last_update = klass.maximum(:updated_at).try(:utc).try(:to_s)
    "#{model.to_s.pluralize}/collection-#{count}-#{last_update}"
  end
end
