# Preview all emails at http://localhost:3000/rails/mailers
class MessageMailerPreview < ActionMailer::Preview
  def welcome
    MessageMailer.contact_message({email: "example@gmail.com", name: "Daniel Romero Esteban"}, "example@gmail.com", "Hola, esto es la previsualización de un email.")
  end
end
