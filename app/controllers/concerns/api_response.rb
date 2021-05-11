# frozen_string_literal: true
module ApiResponse
  def success_response(obj = nil, message = nil, status = :ok)
    render json: {
      data: obj || nil,
      message: message || nil
    }, status: status
  end

  def error_response(message = 'Something went wrong', status = :internal_server_error, obj = nil)
    render json: {
      data: obj || nil,
      error_message: message
    }, status: status
  end
end
