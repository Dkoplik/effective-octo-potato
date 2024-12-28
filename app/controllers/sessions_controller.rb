class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      cookies.signed[:user_id] = {
        value: user.id,
        expires: 1.week.from_now,
        httponly: true
      }
      render json: { message: "Login successful", user: { id: user.id, username: user.username, email: user.email } }, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  def destroy
    cookies.delete(:user_id)
    render json: { message: "Logout successful" }, status: :ok
  end
end
