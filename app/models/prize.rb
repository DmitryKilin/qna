class Prize < ApplicationRecord
  belongs_to :question, inverse_of: :prize
  belongs_to :user, inverse_of: :prizes, optional: true

  has_one_attached :reward
end