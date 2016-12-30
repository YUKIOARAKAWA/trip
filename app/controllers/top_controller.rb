class TopController < ApplicationController
  def index
    @plans = Plan.all
  end
end
