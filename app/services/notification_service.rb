class NotificationService
  def notificate(question)
    NotificationMailer.notification(question).deliver_later 
  end
end
