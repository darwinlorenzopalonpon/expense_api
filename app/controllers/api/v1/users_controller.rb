class Api::V1::UsersController < ApplicationController
  before_action :set_current_user

  def index
    @users = User.all
    render json: @users
  end
end
