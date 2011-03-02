class AdminController < ApplicationController
  before_filter :require_admin

  def show
    @activities = Activity.order('created_at desc').page(params[:page])
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, :notice => 'Hey now.'
    end
  end
end
