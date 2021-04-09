class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :link
  authorize_resource
  
  def destroy
    @link.destroy
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
end
