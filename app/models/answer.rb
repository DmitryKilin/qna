class Answer < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :question, inverse_of: :answers, touch: true
  belongs_to :user, inverse_of: :answers
  has_many :links, as: :linkable, dependent: :destroy

  validates :body, presence: true
  validates_format_of :body, with: /\w+/

  validate :ranked_exclusivity
  scope :ranked, -> { where(ranked: true) }

  has_many_attached :files
  accepts_nested_attributes_for :links, reject_if: :all_blank

  after_create :perfom_subscription

  def rank
    prev_ranked = question.answers.ranked.first
    prize = question.prize

    transaction do
      prize&.update!(user: user)
      prev_ranked&.update!(ranked: false)
      update!(ranked: true)
    end
  end

  def unrank
    transaction do
      question.prize&.update!(user: nil)
      update!(ranked: false)
    end
  end

  def ranked?
    ranked
  end

  private

  def ranked_exclusivity
    if ranked_changed?(from: false, to: true) && question.answers.ranked.count == 1
      errors.add(:ranked, 'Ranked answer must be only one per question.')
    end
  end

  def perfom_subscription
    SubscriptionJob.perform_later(self)
  end
end
