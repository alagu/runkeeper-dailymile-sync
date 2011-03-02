class UsersController < ApplicationController

  before_filter :ensure_signed_out, :only => :new

  def new
  end

  def edit
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to root_path, :flash => { :success => 'Profile updated!' }
    else
      flash[:error] = "Uh oh. Something wasn't right."
      render :edit
    end
  end

  private

  def ensure_signed_out
    if current_user
      redirect_to root_path, :notice => "You're already signed in!"
    end
  end

end
