class UsersController < ApplicationController

  def new
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to root_path, :success => 'Profile updated!'
    else
      flash[:error] = "Uh oh. Something wasn't right."
      render :edit
    end
  end

end
