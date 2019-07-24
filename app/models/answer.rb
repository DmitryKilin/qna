class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  belongs_to :user, inverse_of: :answers

  validates :body, presence: true
  validates_format_of :body, with: /\w+/

  validate :ranked_exclusivity
  scope :ranked, -> {where(ranked: true)}

  def rank
    prev_ranked = question.answers.ranked.first

    unless prev_ranked.nil?
      prev_ranked.ranked = false
      prev_ranked.save
    end

    self.ranked = true
    save
  end

  def ranked_exclusivity
    if ranked_changed?(from: false, to: true) && question.answers.ranked.count == 1
      errors.add(:ranked,  "Ranked answer must be only one per question.")
    end
  end

  def unrank
    self.ranked = false
    save
  end
end


