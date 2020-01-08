class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute(:link) { rewards_user_path(object) }
end
