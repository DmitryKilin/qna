class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    @user = current_user
    render json: @user
  end

  def index
    @users = User.where.not(id: current_user.id)
    render json: @users
  end
end
