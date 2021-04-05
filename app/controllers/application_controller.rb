class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  check_authorization unless: :devise_controller?
  
  private

  def gon_user
    gon.user_id = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json do 
        render status: :forbidden
      end
      format.js do 
        render status: :forbidden 
      end
      format.html do
        redirect_to root_url, alert: exception.message
      end
    end
  end
end
