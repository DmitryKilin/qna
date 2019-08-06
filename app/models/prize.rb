class Prize < ApplicationRecord
  belongs_to :question, inverse_of: :prize

  has_one_attached :reward
end