class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers

  validates :body, :question_id, presence: true
end
