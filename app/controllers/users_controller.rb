class UsersController < ApplicationController
  def create
    user_params = JSON.parse(request.body.read)

    @user = User.new(user_params)

    if @user.save
      UserMailer.confirmation_email(@user).deliver_now
      render json: { message: "User created successfully." }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def confirm
    @user = User.find_by(id: params[:id], confirmation_token: params[:token])

    if @user&.confirm!
      respond_to do |format|
        format.html { redirect_to confirmation_success_path } # Рендерим страницу успеха
        format.json { render json: { message: "Email confirmed successfully." }, status: :ok }
      end
    else
      render json: { errors: [ "Invalid token or user not found." ] }, status: :unprocessable_entity
    end
  end

  def confirmation_success
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end
end
