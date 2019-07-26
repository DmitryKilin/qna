class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :destroy
  belongs_to :user, inverse_of: :questions

  has_many_attached :files

  validates :title, :body, presence: true
end
