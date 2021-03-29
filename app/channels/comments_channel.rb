class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions/#{params[:question_id]}/comments"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
