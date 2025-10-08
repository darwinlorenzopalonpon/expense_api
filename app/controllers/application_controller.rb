class ApplicationController < ActionController::API
  private

  def set_current_user
    user_id = request.headers["X-User-ID"]
    @current_user = User.find_by(id: user_id)

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def render_service_response(result, serializer: nil)
    if result[:success]
      render json: result[:data], serializer: serializer, status: :ok
    else
      render json: { error: result[:message] }, status: result[:type]
    end
  end
end
