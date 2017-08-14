class MypageController < ApplicationController
  before_action :authenticate_user!

  def top
    @user = User.find(params[:id])
    @my_plans = @user.plans
    @plan = Plan.new
  end
end
