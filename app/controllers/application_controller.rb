class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  private

  def set_current_user
    @current_user = User.find_by(id: cookies.signed[:user_id]) if cookies.signed[:user_id]
  end

  def authenticate_user!
    unless @current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
