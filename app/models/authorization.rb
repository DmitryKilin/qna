class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: :true

  def email_confirmed?
    confirmation_code.nil?
  end
end
