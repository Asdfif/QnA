class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :file

  def delete_file
    @file.purge if current_user.owner_of?(@file.record)
  end

  private

  def file
    @file ||= ActiveStorage::Attachment.find(params[:file_id]) 
  end
end
