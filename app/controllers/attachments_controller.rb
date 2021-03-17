class AttachmentsController < ApplicationController
  def delete_file
    authenticate_user!
    @file_id = params[:file_id]
    ActiveStorage::Attachment.find(params[:file_id]).purge
  end
end
