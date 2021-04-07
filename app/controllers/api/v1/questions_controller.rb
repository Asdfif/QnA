class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[answers show]
  def index
    @questions = Question.all
    authorize! :index, current_resource_owner
    render json: @questions, each_serializer: QuestionsSerializer, root: "questions"
  end

  def show
    authorize! :answers, current_resource_owner
    render json: @question, serializer: QuestionSerializer
  end

  private

  def set_question
    @question ||= Question.find(params[:id])
  end
end