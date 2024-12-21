class AccountController < ApplicationController
  def delete_account
    username = params[:username]
    password = params[:password]
    user = User.find_by(username: username)

    if user && user.authenticate(password)
      user.destroy
      render json: { message: "Account deleted successfully" }, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end
end
