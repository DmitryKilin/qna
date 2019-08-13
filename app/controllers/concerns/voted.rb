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
    @obj ||= model_klass.find(params[:id])
  end

  def make_vote(method)
    obj_votable

    return head :forbidden if current_user&.author?(@obj)

    if @obj.send(method, current_user)
      render json: { votableType: @obj.class.name.downcase,
                     votableId: @obj.id,
                     PollRezult: @obj.amount }
    else
      head :forbidden
    end
  end
end