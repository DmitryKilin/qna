class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :delete_all
  belongs_to :user, inverse_of: :questions

  validates :title, :body, presence: true
end
