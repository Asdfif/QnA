class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :question, except: %i[create]
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.update(question_params) if current_user.owner_of?(@question)
  end

  def delete_file
    @file_id = params[:file_id]
    delete_file_from_resource(@question, @file_id)
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

  #helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, :file_id, files: [])
  end
end
