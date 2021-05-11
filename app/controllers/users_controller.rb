class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    data = { users: User.all }
    success_response(data)
  end

  def show
    data = { user: @user }
    success_response(data)
  end

  def create
    @user = User.create(create_params)
    if @user.id
      data = { user: @user }
      success_response(data)
    else
      error_response(@user.errors.messages)
    end
  end

  def update
    if @user.update(update_params)
      data = { user: @user }
      success_response(data)
    else
      error_response(@user.errors.messages)
    end
  end

  def destroy
    @user.destroy!
    data = { user: @user }
    success_response(data)
  end

  private

  def set_user
    @user = User.find_by_id(params[:id])
    error_response("User #{params[:id]} not found.", 404) unless @user
  end

  def create_params
    params.require(:user).permit(:name, :email)
  end

  def update_params
    params.require(:user).permit(:name, :email)
  end
end
