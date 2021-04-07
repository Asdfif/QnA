class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[index create]
  before_action :set_answer, only: %i[show]
  
  def index
    @answers = @question.answers
    authorize! :index, current_resource_owner
    render json: @answers, each_serializer: AnswersSerializer, root: "answers"
  end

  def show
    authorize! :show, current_resource_owner
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    authorize! :create, current_resource_owner
    @answer = current_resource_owner.answers.build(answer_params)
    @answer.question = @question
    if @answer.save
      render json: @answer, serializer: AnswerSerializer
    end
  end

  private

  def set_question
    @question ||= Question.find(params[:question_id])
  end

  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, 
                                   files: [], 
                                   links_attributes: [:name, :url, :_destroy])
  end
end