class BaseService
  def initialize(current_user = nil)
    @current_user = current_user
  end

  def call
    raise NotImplementedError
  end

  private

  def success(message: nil, data: nil)
    {
      success: true,
      message: message,
      data: data
    }
  end

  def error(message: nil, type: :unprocessable_entity)
    {
      success: false,
      message: message,
      type: type
    }
  end
end
