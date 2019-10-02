class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :answers, inverse_of: :user
  has_many :questions, inverse_of: :user
  has_many :prizes, inverse_of: :user
  has_many :authorizations, inverse_of: :user, dependent: :destroy


  def author?(some_instance)
    some_instance&.user_id == self.id
  end

  def attachment_owner?(file)
    author?(Object.const_get(file.record_type).find(file.record_id))
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
