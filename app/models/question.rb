class Question < ApplicationRecord
  has_many :answers, inverse_of: :question, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy

  belongs_to :user, inverse_of: :questions

  accepts_nested_attributes_for :links, reject_if: :all_blank
  has_many_attached :files
  has_one_attached :reward

  validates :title, :body, presence: true
end
