class Question < ApplicationRecord
<<<<<<< HEAD
  has_many :answers, inverse_of: :question, dependent: :delete_all

=======
>>>>>>> 65baf0b... 23-07_13-06-2019
  validates :title, :body, presence: true
end
