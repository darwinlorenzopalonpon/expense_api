class ApplicationController < ActionController::API
  def fallback_index_html
    render file: Rails.public_path.join("index.html")
  end

  private

  def set_current_user
    user_id = request.headers["X-User-ID"]
    @current_user = User.find_by(id: user_id)

    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user
  end

  def render_service_response(result, serializer: nil)
    if result[:success]
      data = result[:data]
      if data.respond_to?(:each)
        render json: data, each_serializer: serializer, status: :ok
      else
        render json: data, serializer: serializer, status: :ok
      end
    else
      render json: { error: result[:message] }, status: result[:type]
    end
  end
end
