class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :definition, presence: true, inclusion: { in: [1, -1] }
  validates :votable, uniqueness: { scope: :user }
end