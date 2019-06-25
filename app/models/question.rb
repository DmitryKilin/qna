class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :delete_all
  belongs_to :author, class_name: "User", inverse_of: :authorships

  validates :title, :body, presence: true
end
