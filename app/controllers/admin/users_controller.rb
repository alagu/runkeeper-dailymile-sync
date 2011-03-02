class Admin::UsersController < ApplicationController
  def index
    @users = User.order(:id).page(params[:page])
  end
end
