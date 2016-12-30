class MypageController < ApplicationController
  before_action :authenticate_user!

  def top
    @user = User.find(params[:id])
    @myplans = @user.plans
    @plan = Plan.new
  end

  def xxx
  end
end
