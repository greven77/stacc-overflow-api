class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  include Pundit

  before_action :authorize_request
  attr_reader :current_user

  private

  def authorize_request
    @current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
  end

  def not_authorized
    render json: { error: "Unauthorized" }, status: 403
  end

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
end
