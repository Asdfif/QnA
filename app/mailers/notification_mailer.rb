class NotificationMailer < ApplicationMailer

  def notification(user)
    @notification = 'You have new answer'

    email to: user.email,
          template_path: 'mailers/notification'
  end

end
