class UsersController < ApplicationController
  def create
    user_params = JSON.parse(request.body.read)

    @user = User.new(user_params)

    if @user.save
      UserMailer.confirmation_email(@user).deliver_now
      render json: { message: "User created successfully. Please confirm your email.", user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def confirm
    @user = User.find_by(id: params[:id], confirmation_token: params[:token])

    if @user&.confirm!
      render json: { message: "Email confirmed successfully." }, status: :ok
    else
      render json: { errors: [ "Invalid token or user not found." ] }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
