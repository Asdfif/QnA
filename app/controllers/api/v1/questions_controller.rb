class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[answers show destroy update]
  before_action :authorize_user, only: %i[show create update destroy]
  
  def index
    @questions = Question.all
    authorize_user
    render json: @questions, each_serializer: QuestionsSerializer, root: "questions"
  end

  def show
    authorize! :show, current_resource_owner
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.build(question_params)
    if @question.save
      render json: @question, serializer: QuestionSerializer
    else
      render json: { message: 'bad request' }, status: :bad_request
    end
  end
  
  def update
    if current_resource_owner.owner_of?(@question) && @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      render json: { message: 'bad request' }, status: :bad_request
    end
  end

  def destroy
    if current_resource_owner.owner_of?(@question)
      @question.destroy
      render json: { message: "#{@question.title} deleted", status: 200 }
    end
  end

  private

  def authorize_user
    authorize! params['action'].to_sym, current_resource_owner
  end

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