class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers, inverse_of: :user
  has_many :questions, inverse_of: :user

  def author?(some_instance)
    some_instance&.user_id == self.id
  end

  def attachment_owner?(file)
    author?(Object.const_get(file.record_type).find(file.record_id))
  end

  def rewarded_answers
    self.answers.ranked
  end

end
