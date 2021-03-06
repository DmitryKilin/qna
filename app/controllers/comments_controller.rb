class CommentsController < ApplicationController
  before_action :find_comment, only: %i[show destroy]
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = commented_resource_instance.comments.new(body: comment_params[:body])
    @comment.user = current_user
    if @comment.save
      render json: comment_data
    else
      render json: @comment.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.author?(@comment)
      @comment.destroy
      note = 'Comment have been deleted!'
    else
      note = 'You can delete yours questions only!'
    end
    redirect_to root_path, notice: note
  end

  def show; end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def resource_id
    params[params_resource_key]
  end

  def params_resource_key
    params.keys.find { |p| p.match?(/_id$/) }
  end

  def resource_klass
    params_resource_key.humanize.constantize
  end

  def commented_resource_instance
    resource_klass.find(resource_id)
  end

  def comment_data
    { id: @comment.id,
      body: @comment.body,
      user_email: current_user.email,
      commented_resource: @comment.commentable_type.downcase,
      commented_resource_id: @comment.commentable_id }
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast('comments', comment_data)
  end
end
