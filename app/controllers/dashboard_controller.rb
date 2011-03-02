class DashboardController < ApplicationController

  before_filter :require_user

  def show
    @activities = current_user.activities.order('created_at desc')
  end
end
