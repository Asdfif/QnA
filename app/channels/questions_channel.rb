class QuestionsChannel < ApplicationCable::Channel
  def echo(data)
    transmit(data)
  end

  def subscribed
    stream_from "questions"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
