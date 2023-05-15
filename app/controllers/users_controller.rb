class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create
  before_action :list_user
  def create
    if email_not_in_user_list?(user_params['email'])
      user = User.create!(user_params)
      auth_token = AuthenticateUser.new(user.email, user.password).call
      response = { message: Message.account_created, auth_token: }
      status = :created
    else
      response = { message: 'User with that email already exist!' }
      status = :conflict
    end
    json_response(response, status)
  end

  private

  def user_params
    params.permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def list_user
    @user = User.all
  end

  def email_not_in_user_list?(email)
    @user.where(email:).empty?
  end
end
