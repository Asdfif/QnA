class LinksController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  before_action :link
  
  def destroy
    @link.destroy if current_user.owner_of?(@link.linkable)
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
end
