class RankedExclusivity < ActiveModel::Validator
  def validate(record)
    if record.ranked? && record.question.answers.ranked.count == 1
      record.errors[:ranked] << "Ranked answer must be only one per question."
    end
  end
end

class Answer < ApplicationRecord
  belongs_to :question, inverse_of: :answers
  belongs_to :user, inverse_of: :answers

  validates :body, presence: true
  validates_format_of :body, with: /\w+/

  validates_with RankedExclusivity
  scope :ranked, -> {where(ranked: true)}
end


