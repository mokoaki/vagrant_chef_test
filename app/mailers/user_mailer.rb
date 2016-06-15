class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user

    subject = 'タイトルです'
    to      = Rails.application.secrets.gmail_address

    mail(to: to, subject: subject)
  end
end
