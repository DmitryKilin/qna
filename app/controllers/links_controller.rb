class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_link, only: :destroy

  def destroy
    @link.destroy if current_user.author?(@link.linkable)
  end

  def find_link
    @link = Link.find(params[:id])
  end
end
