class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[answers]
  def index
    @questions = Question.all
    authorize! :index, current_resource_owner
    render json: @questions
  end

  def answers
    @answers = @question.answers
    authorize! :answers, current_resource_owner
    render json: @answers, each_serializer: AnswerSerializer, root: "answers"
  end

  private

  def set_question
    @question ||= Question.find(params[:id])
  end
end