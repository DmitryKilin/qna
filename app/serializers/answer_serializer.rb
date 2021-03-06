class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute(:link) { answer_path(object) }
  attribute(:label) { object.body }
end
