class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers

  validates :body, presence: true
end
