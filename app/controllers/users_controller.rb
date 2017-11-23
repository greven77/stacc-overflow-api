class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token, email: user.email,
                 id: user.id}
    json_response(response, :created)
  end

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
