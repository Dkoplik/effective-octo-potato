class UserMailer < ApplicationMailer
  default from: "effective-octo-potato@mail.ru"

  def confirmation_email(user)
    @user = user
    @confirmation_url = "http://localhost:3000/users/#{user.id}/confirm?token=#{user.confirmation_token}"

    mail(to: @user.email, subject: "Email Confirmation")
  end
end
