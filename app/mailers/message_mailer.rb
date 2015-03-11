class MessageMailer < ApplicationMailer
  def contact_message(user, email, message)
    @user = user
    @email = email
    @message = message
    mail(to: ENV['CONTACT_EMAIL'], subject: 'Mensaje de contacto')
  end
end