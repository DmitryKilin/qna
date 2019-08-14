module Voted
  extend ActiveSupport::Concern

  def vote_up
    make_vote(:poll_up)
  end

  def vote_down
    make_vote(:poll_down)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def obj_votable
    model_klass.find(params[:id])
  end

  def make_vote(method)
    votable = obj_votable

    return head :forbidden if current_user&.author?(votable)

    if votable.send(method, current_user)
      render json: { votableType: votable.class.name.downcase,
                     votableId: votable.id,
                     pollResult: votable.amount }
    else
      head :forbidden
    end
  end
end