module Commented
  extend ActiveSupport::Concern

  ApplicationController::after_action :publish_comment, only: %i[comment]

  def comment
    @comment = commented_instance.comments.new(body: comment_params[:comment_body])
    @comment.user = current_user
    if @comment.save
      render json: comment_data
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.permit(:comment_body)
  end

  def commented_resource_name
    controller_name.singularize
  end

  def commented_instance
    controller_name.classify.constantize.find(params[:id])
  end

  def comment_data
    {comment_id: @comment.id,
     comment_body: @comment.body,
     user_email: current_user.email,
     commented_resource: @comment.commentable_type.downcase,
     commented_resource_id: @comment.commentable_id
    }
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast('comments', comment_data)

  end
end