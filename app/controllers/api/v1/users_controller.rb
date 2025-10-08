class Api::V1::UsersController < ApplicationController
  def index
    @users = User.all
    render json: @users, each_serializer: Api::V1::UserSerializer
  end
end
