class NotificationMailer < ApplicationMailer

  def notification(question)
    @notification = "You have new answer to question: #{question.title}"

    question.subscribers.find_each do |subscriber|
      email to: subscriber.email,
            template_path: 'mailers/notification'
    end
  end
end
