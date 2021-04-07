class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[answers show]
  def index
    @questions = Question.all
    authorize! :index, current_resource_owner
    render json: @questions, each_serializer: QuestionsSerializer, root: "questions"
  end

  def show
    authorize! :show, current_resource_owner
    render json: @question, serializer: QuestionSerializer
  end

  def create
    authorize! :create, current_resource_owner
    @question = current_resource_owner.questions.build(question_params)
    if @question.save
      render json: @question, serializer: QuestionSerializer
    end
  end

  private

  def set_question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, 
                                     :body, 
                                     links_attributes: [:name, :url, :_destroy],
                                     reward_attributes: [:title, :img_url, :_destroy])
  end
end