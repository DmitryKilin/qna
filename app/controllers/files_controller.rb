class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_file, only: :destroy

  authorize_resource

  def destroy
      @file.purge if current_user&.attachment_owner?(@file)
  end

  def find_file
    @file = ActiveStorage::Attachment.find(params[:id])
  end
end
