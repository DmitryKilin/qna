class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  belongs_to :user, inverse_of: :answers

  validates :body, presence: true
  validates_format_of :body, with: /\w+/

  validate :ranked_exclusivity
  scope :ranked, -> {where(ranked: true)}

  def rank
    prev_ranked = question.answers.ranked.first

    Answer.transaction do
      prev_ranked.update!(ranked: false) unless prev_ranked.nil?
      self.update!(ranked: true)
    end
  end



  def unrank
    self.update(ranked: false)
  end

  private

  def ranked_exclusivity
    if ranked_changed?(from: false, to: true) && question.answers.ranked.count == 1
      errors.add(:ranked,  "Ranked answer must be only one per question.")
    end
  end
end


