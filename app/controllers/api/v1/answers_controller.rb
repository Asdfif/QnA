class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index]
  before_action :set_answer, only: %i[show]
  
  def index
    @answers = @question.answers
    authorize! :answers, current_resource_owner
    render json: @answers, each_serializer: AnswersSerializer, root: "answers"
  end

  def show
    authorize! :answers, current_resource_owner
    render json: @answer, serializer: AnswerSerializer
  end

  private

  def set_question
    @question ||= Question.find(params[:question_id])
  end

  def set_answer
    @answer ||= Answer.find(params[:id])
  end
end