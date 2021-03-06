class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[github vkontakte]

  has_many :answers, inverse_of: :user
  has_many :questions, inverse_of: :user
  has_many :prizes, inverse_of: :user
  has_many :authorizations, inverse_of: :user, dependent: :destroy
  has_many :subscriptions, inverse_of: :user, dependent: :destroy
  has_many :subscribed_questions, through: :subscriptions, source: :question

  def author?(some_instance)
    some_instance&.user_id == id
  end

  def attachment_owner?(file)
    author?(Object.const_get(file.record_type).find(file.record_id))
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization!(auth)
    authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def subscribed_to?(question)
    subscribed_questions.exists?(question.id)
  end

  def subscription_for(question)
    subscriptions.where(question: question).first
  end
end
