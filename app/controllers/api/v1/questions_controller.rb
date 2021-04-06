class Api::V1::QuestionsController < Api::V1::BaseController
  skip_authorization_check
  def index
    @questions = Question.all
    # authorize! :me, current_resource_owner
    render json: @questions
  end
end