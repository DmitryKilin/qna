module Voted
  extend ActiveSupport::Concern

  def vote_up
    make_vote(:poll_up)
  end

  def vote_down
    make_vote(:poll_down)
  end

  private

  def make_vote(method)
    votable = controller_name.classify.constantize.find(params[:id])

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