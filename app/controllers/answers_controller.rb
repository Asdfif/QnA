class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :answer, only: %i[update destroy make_it_best]

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = question
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.owner_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.owner_of?(@answer)
  end

  def make_it_best
    if current_user&.owner_of?(@answer.question)
      @prev_best_answer_id = @answer.question.best_answer&.id
      @answer.make_it_best
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
    params.require(:answer).permit(:body, files: [])
  end
end
