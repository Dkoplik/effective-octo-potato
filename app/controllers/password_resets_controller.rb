class PasswordResetsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])

    if user
      user.generate_reset_password_token!
      PasswordResetMailer.reset_password_email(user).deliver_now # Передаем user в mailer
      render json: { message: "Password reset instructions have been sent to your email" }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:token])

    if @user && @user.reset_password_period_valid?
      respond_to do |format|
        format.html # Отдаст представление edit.html.erb
        format.json { render json: { message: "Please enter your old and new password." }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render plain: "Invalid or expired token", status: :not_found }
        format.json { render json: { error: "Invalid or expired token" }, status: :not_found }
      end
    end
  end

def update
  @user = User.find_by(reset_password_token: params[:token])

  if @user && @user.reset_password_period_valid?
    if @user.authenticate(params[:old_password]) # Проверка старого пароля
      if @user.update(password: params[:new_password])
        @user.update(reset_password_token: nil, reset_password_sent_at: nil) # Сброс токена
        redirect_to success_password_reset_path, notice: "Password successfully updated!"
      else
        flash.now[:alert] = "Ошибка: " + @user.errors.full_messages.join(", ")
        render :edit, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Старый пароль неверный"
      render :edit, status: :unprocessable_entity
    end
  else
    redirect_to root_path, alert: "Password reset token has expired or is invalid."
  end
end

def success
end
end
