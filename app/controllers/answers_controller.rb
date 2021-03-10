class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    question
  end

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = question
    if @answer.save
      redirect_to @answer.question
    else
      render "questions/show"
    end
  end

  def destroy
    if current_user.owner_of?(answer)
      answer.destroy 
      redirect_to question_path(answer.question), notice: 'Answer deleted'
    else
      redirect_to question_path(answer.question), notice: "You can't to that"
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
