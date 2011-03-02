class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user  
    
  private  

  def current_user  
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end

  def require_user
    unless current_user 
      redirect_to signup_path, :notice => 'You need to be logged in to do that!'
    end
  end
end
