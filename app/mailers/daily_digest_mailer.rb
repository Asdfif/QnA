class DailyDigestMailer < ApplicationMailer

  def digest(user)
    @greeting = 'hi'

    email to: user.email
  end

end
