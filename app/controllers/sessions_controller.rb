class SessionsController < ApplicationController
  respond_to :html

  def create
    auth = request.env["omniauth.auth"]  
    Rails.logger.info auth.to_yaml
    @user = User.find_by_provider_and_dailymile_id(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth) 
    session[:user_id] = @user.id  
    respond_with @user do |format|
      format.html { redirect_to root_url, :notice => "Okay, you're signed in!" }
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
