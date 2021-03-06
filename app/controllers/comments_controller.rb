class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: %i[create]
  authorize_resource
  
  after_action :publish_comment, only: %i[create]

  def create
    @comment = @commentable.comments.create(
      comment_params.merge({ user: current_user })
    )
  end

  private

  def set_commentable
    @commentable ||= Answer.find(params[:answer_id]) if params[:answer_id]
    @commentable ||= Question.find(params[:question_id]) if params[:question_id]
  end

  def model_klass
    controller_name.classify.constantize
  end

  def question_id
    if params[:question_id]
      return @commentable.id 
    elsif params[:answer_id]
      return @commentable.question_id
    end
  end

  def publish_comment
    return if @comment.errors.any?
    ActionCable.server.broadcast( 
      "questions/#{question_id}/comments", 
      author_id: @comment.user_id, 
      author_email: @comment.user.email,
      commentable_klass: @commentable.class.to_s.underscore,
      commentable_id: @commentable.id,
      body: @comment.body,
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
