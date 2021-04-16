class NotificationService
  def notificate(question)
    NotificationMailer.notification(question.user).deliver_later 
  end
end
