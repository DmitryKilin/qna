# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
    can :me, User
    can :search, :all
    can :show_answers, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user: user
    can :destroy, [Question, Answer, Comment], user: user
    can :create, Prize, question: { user_id: user.id }

    can :manage, ActiveStorage::Attachment do |file|
      user.author? file.record
    end

    can [:vote_up, :vote_down], [Question, Answer] do |poll|
      !user.author? poll
    end
    can [:star, :unstar], Answer, question: { user_id: user.id }
    can :rewards, User, user: user

    can %i[create destroy], Link, linkable: { user_id: user.id }
  end
end
