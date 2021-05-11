class ApplicationController < ActionController::API
  include ApiResponse

  def no_route
    error_response('Route not found', 404)
  end
end
