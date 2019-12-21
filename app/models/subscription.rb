class Subscription < ApplicationRecord
  belongs_to :user, inverse_of: :subscriptions
  belongs_to :question, inverse_of: :subscriptions

  validates :user, :question, presence: true
end
