class QuestionsController < ApplicationController
  include Voted
  
  before_action :authenticate_user!, except: %i[index show]
  before_action :question, except: %i[create]

  after_action :publish_question, only: %i[create]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
  end

  def new
    @question.links.build
    @question.build_reward
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    end
  end

  def update
    @question.update(question_params) if current_user.owner_of?(@question)
  end

  def destroy
    if current_user.owner_of?(question)
      question.destroy 
      redirect_to questions_path, notice: 'Question deleted'
    else
      redirect_to question_path(question), notice: "You can't to that"
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, 
                                     :body, 
                                     files: [], 
                                     links_attributes: [:name, :url, :_destroy],
                                     reward_attributes: [:title, :img_url, :_destroy])
  end

  # def publish_question
  #   return if @question.errors.any?
  #   ActionCable.server.broadcast(
  #     'questions',
  #     ApplicationController.render(
  #       partial: 'questions/question', 
  #       locals: { question: @question }
  #     )
  #   )
  # end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast( 'questions', render_question )
  end

  def render_question
    ApplicationController.renderer.instance_variable_set(:@env, { "warden" => warden })

    ApplicationController.render(
      partial: 'questions/questions',
      locals: { questions: Question.all })
  end
end
