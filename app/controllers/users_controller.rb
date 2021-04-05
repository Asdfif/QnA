class UsersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource
  
  def rewards
    @rewards = current_user&.rewards
  end
end
