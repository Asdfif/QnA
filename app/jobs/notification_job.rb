class NotificationJob < ApplicationJob
  queue_as :default

  def perform(question)
    NotificationService.new.notificate(question)
  end
end
