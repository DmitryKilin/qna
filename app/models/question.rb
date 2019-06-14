class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :delete_all

  validates :title, :body, presence: true
end
