class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  before_action :set_user, only: [:show, :update]

  def show
    json_response(@user)
  end

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token, email: user.email,
                 id: user.id}
    json_response(response, :created)
  end

  def update
    if @user.update(user_params)
      render json: @user, status: 201
    else
      render json: @user.errors, status: 422
    end
  end

  def user_params
    params.permit(:username, :email, :password, :password_confirmation,
                  :profile_pic)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
