class SubscribesController < ApplicationController
  before_action :authenticate_user!
  before_action :question, only: %i[create]
  before_action :subscribe, only: %i[destroy]

  authorize_resource
  
  def create
    if @question.subscribers.push(current_user)
      redirect_to question_path(question)
    end
  end

  def destroy
    if @subscribe.destroy
      redirect_to question_path(@subscribe.question)
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def subscribe
    @subscribe ||= Subscribe.find(params[:id])
  end
end
