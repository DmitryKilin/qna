module Commented
  extend ActiveSupport::Concern

  def comment
    @comment = commented_instance.comments.new(body: comment_params[:comment_body])
    @comment.user = current_user
    if @comment.save
      render json: {comment_id: @comment.id,
                    comment_body: @comment.body,
                    user_email: current_user.email,
                    commented_resource: commented_resource_name
      }
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(commented_resource_name).permit(:comment_body)
  end

  def commented_resource_name
    controller_name.singularize
  end

  def commented_instance
    controller_name.classify.constantize.find(params[:id])
  end
end