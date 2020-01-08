class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :files
  has_many :comments
  has_many :links
  belongs_to :user

  def files
    return unless object.files.attached?

    object.files.map do |file|
      Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
    end
    end
end
