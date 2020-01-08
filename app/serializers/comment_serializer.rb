class CommentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute(:link) { comment_path(object) }
end
