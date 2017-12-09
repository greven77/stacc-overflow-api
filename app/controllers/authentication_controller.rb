class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    user = User.find_by(email: auth_params[:email]) if auth_token
    json_response(auth_token: auth_token, user: UserSerializer.new(user, signin: true))
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
