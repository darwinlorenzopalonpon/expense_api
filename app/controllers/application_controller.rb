class ApplicationController < ActionController::API
  private

  def set_current_user
    user_id = request.headers["X-User-ID"]
    @current_user = User.find_by(id: user_id)

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end
end
