class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      render json: { message: "Login successful", user: { id: user.id, username: user.username, email: user.email } }, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  def destroy
    reset_session
    render json: { message: "Logout successful" }, status: :ok
  end
end
