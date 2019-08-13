module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  DEFINITIONS = { up: 1, down: -1}.freeze

  def amount
    votes.sum( :definition )
  end

  def poll_up(user)
    vote(user, :up)
  end

  def poll_down(user)
    vote(user, :down)
  end

  private

  def find_prev_vote(voter)
    votes.find_by(user: voter)
  end

  def opinion_changed?( prev_definition, new_definition )
    ( prev_definition + new_definition ).zero?
  end

  def vote(voter, option)
    return false if voter.author?(self)

    prev_vote = find_prev_vote(voter)
    if prev_vote
      prev_vote.delete if opinion_changed?(prev_vote.definition, DEFINITIONS[option])
    else
      votes.create(user: voter, definition: DEFINITIONS[option])
    end
  end
end