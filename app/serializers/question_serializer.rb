class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attribute(:link) { question_path(object) }
  attribute(:label) { object.title }
end
