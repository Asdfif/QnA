class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[answers show destroy update]
  
  def index
    authorize! :index, Question
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer, root: "questions"
  end

  def show
    authorize! :show, @question
    render json: @question, serializer: QuestionSerializer
  end

  def create
    authorize! :create, Question
    @question = current_resource_owner.questions.build(question_params)
    if @question.save
      render json: @question, serializer: QuestionSerializer
    else
      render json: { message: 'bad request' }, status: :unprocessible_entity
    end
  end
  
  def update
    authorize! :update, @question
    if @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      render json: { message: 'bad request' }, status: :unprocessible_entity
    end
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy
    render json: { message: "#{@question.title} deleted", status: 200 }
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